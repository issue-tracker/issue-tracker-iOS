//
//  IssueDetailViewModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/13.
//

import Foundation
import RxSwift
import RxRelay

enum IssueDetailError: Error {
    case iDError
    case memberIdError
    case tokenUnavailableError
    case responseWithError
    case urlError
    case errorOnBody
}

enum IssueDetailCellType {
    case separator
    case info
}

// RequestHTTPModel 을 상속하는 이유는 여러가지의 response 가 있을 수 있기 때문.
// 다양한 HTTP Response Body 에 대응해야 한다.
class IssueDetailViewModel: RequestHTTPModel, ViewBindable {
    
    private var issueId: Int = 1 // Test 를 위한 Default 값 삽입.
    
    private var bagCount = 0
    /// Model 에서 DisposeBag 을 관리하는 이유는 효율적인 메모리 관리(4 번 이상의 리퀘스트 이후에는 DisposeBag 을 초기화 ) 를 위함입니다.
    ///
    /// Model 의 DisposeBag 을 이용하시는 것을 권해드립니다.
    var bag = DisposeBag() {
        didSet {
            bagCount += 1
            if bagCount >= 2 {
                bag = DisposeBag()
            }
        }
    }
    var emojis: [String] = []
    
    private var responseModel: HTTPResponseModel {
        return HTTPResponseModel()
    }
    
    var binding: ViewBinding?
    
    // Entities for DetailView
    var issueDetail: IssueListEntity?
    
    var issueContents: Content? // Main Contents. 맨 위에 위치할 IssueListComment
    var issueSubContents: [Content] = [] // Main Contents 밑에 위치할 컨텐츠.
    var contentsCount: Int {
        return issueSubContents.count + (issueContents == nil ? 0 : 1)
    }
    
    var commentsOfIssue: [IssueListComment]? { issueDetail?.comments }
    var authorInfo: IssueListAuthor? { issueDetail?.author }
    var assigneeInfo: [IssueAssignee]? { issueDetail?.issueAssignees }
    var labelsInfo: [LabelListEntity]? { issueDetail?.issueLabels }
    var milestoneInfo: MilestoneListEntity? { issueDetail?.milestone }
    var historiesOfIssue: [IssueHistories]? { issueDetail?.issueHistories }
    var historySubject = PublishRelay<[IssueHistories]>()
    
    override init(_ baseURL: URL) {
        super.init(baseURL)
    }
    
    convenience init?(issueId: Int) throws {
        guard let url = URL.issueApiURL else {
            return nil
        }
        
        self.init(url)
        self.issueId = issueId
    }
    
    // MARK: - Utils
    
    private func responseFlatten<T: Decodable>(_ ob: Observable<Data>) -> Observable<T?> {
        ob.flatMap { [weak self] data -> Observable<T?> in
            guard let self = self else { return Observable.never() }
            
            if let message = self.responseModel.getMessageResponse(from: data) {
                self.binding?.bindableHandler?(message, self)
                return Observable.never()
            }
            
            let entity = self.responseModel.getDecoded(from: data, as: T.self)
            if let issueDetail = entity as? IssueListEntity {
                self.issueDetail = issueDetail
                self.setissueContents()
            }
            
            return Observable.just(entity)
        }
    }
    // TODO: Comments first 는 맨 위의 메인 컨텐츠로 만들기.
    private func setissueContents() {
        guard var issueDetailComments = issueDetail?.comments, issueDetailComments.count >= 1 else { // comments 는 있어야 Main Contents를 추가할 수 있음.
            return
        }
        
        issueDetailComments.sort(by: { self.constructDate(from: $0.createdAt) < self.constructDate(from: $1.createdAt) })
        self.issueContents = issueDetailComments.first?.getContents()
        issueDetailComments.removeFirst()
        
        let comparableItems: [Any] = (issueDetail?.issueHistories ?? []) + issueDetailComments
        self.issueSubContents = comparableItems.compactMap { item in
            if let item = item as? IssueHistories {
                return item.getContents()
            } else if let item = item as? IssueListComment {
                return item.getContents()
            } else {
                return nil
            }
        }
        
        self.issueSubContents.sort { $0.date < $1.date }
    }
    
    func constructDate(from dateString: String?) -> Date {
        guard let dateString = dateString, let date = DateFormatter().date(from: dateString) else {
            return Date()
        }
        
        return date
    }
    
    // MARK: - APIs
    func getDetailEntity() -> Observable<IssueListEntity?> {
        return responseFlatten(requestObservable(pathArray: ["\(issueId)"]))
    }
    
    func getCellEntity(_ indexPath: IndexPath) -> Content? {
        if indexPath.row == 0 {
            return self.issueContents
        } else {
            return issueSubContents[indexPath.row-1]
        }
    }
    
    func getCellHeight(_ indexPath: IndexPath) -> Float {
        guard let entity = getCellEntity(indexPath) else {
            return 120
        }
        
        switch entity.cellType {
        case .separator:
            return 30
        case .info:
            return 120
        }
    }
    
    // title, status, emojis
    func setTitle(_ title: String) -> Observable<IssueListEntity?> {
        builder.setBody( ["id": self.issueId] )
        return responseFlatten(requestObservable(pathArray: [
            "\(issueId)", "title"
        ]))
    }
    
    func setStatus(_ status: Bool) -> Observable<IssueListEntity?> {
        guard let body = try? JSONSerialization.data(withJSONObject: ["status": status, "ids": [issueId]], options: .prettyPrinted) else {
            return Observable.create { observer in
                let disposables = Disposables.create()
                observer.onError(IssueDetailError.errorOnBody)
                observer.onCompleted()
                return disposables
            }
        }
        
        builder.setBody(body)
        return responseFlatten(requestObservable(pathArray: ["update-status"]))
    }
    
    func getEmojis() -> Observable<[EmojiResponse]?> {
        responseFlatten(requestObservable(pathArray: [
            "comments", "reactions", "emojis"
        ]))
    }
    
    // label
    func setLabel(_ labelId: Int) -> Observable<IssueListEntity?> {
        responseFlatten(requestObservable(pathArray: [
            "\(issueId)", "labels", "\(labelId)"
        ]))
    }
    
    func deleteLabel(_ labelId: Int) -> Observable<String?> {
        requestObservable(pathArray: [
            "\(issueId)", "labels", "\(labelId)"
        ])
        .map { [weak self] in
            self?.responseModel.getMessageResponse(from: $0)
        }
    }
    
    // comment
    func setComment(_ content: String) -> Observable<IssueListEntity?> {
        builder.setBody(["content": content])
        return responseFlatten(requestObservable(pathArray: [
            "\(issueId)", "comments"
        ]))
    }
    
    func deleteComment(_ commentId: Int) -> Observable<String?> {
        requestObservable(pathArray: [
            "\(issueId)", "comments", "\(commentId)"
        ])
        .map { [weak self] in
            self?.responseModel.getMessageResponse(from: $0)
        }
    }
    
    func updateComment(_ commentId: Int, content: String) -> Observable<IssueListEntity?> {
        builder.setBody(["content": content])
        return responseFlatten(requestObservable(pathArray: [
            "\(issueId)", "comments", "\(commentId)"
        ]))
    }
    
    func setReactionTo(commentId: Int, emojiName: String) -> Observable<IssueListEntity?> {
        responseFlatten(requestObservable(pathArray: [
            "\(issueId)", "comments", "\(commentId)", "reactions", "\(emojiName)"
        ]))
    }
    
    func deleteReactionTo(commentId: Int, reactionId: Int) -> Observable<String?> {
        requestObservable(pathArray: [
            "\(issueId)", "comments", "\(commentId)", "reactions", "\(reactionId)"
        ])
        .map { [weak self] in
            self?.responseModel.getMessageResponse(from: $0)
        }
    }
    
    // assignee
    func setAssignee(_ assigneeId: Int) -> Observable<IssueListEntity?> {
        responseFlatten(requestObservable(pathArray: [
            "\(issueId)", "assignees","\(assigneeId)"
        ]))
    }
    
    func deleteAssignee(_ assigneeId: Int) -> Observable<String?> {
        builder.setURLQuery([
            "clear": "true", "assigneeId": "\(assigneeId)"
        ])
        
        return requestObservable(pathArray: [
            "\(issueId)", "assignees"
        ])
        .map { [weak self] in
            self?.responseModel.getMessageResponse(from: $0)
        }
    }
    
    // milestone
    func setMilestone(_ milestoneId: Int) -> Observable<IssueListEntity?> {
        responseFlatten(requestObservable(pathArray: [
            "\(issueId)", "milestone", "\(milestoneId)"
        ]))
    }
    
    func deleteMilestone(_ milestoneId: Int) -> Observable<String?> {
        requestObservable(pathArray: [
            "\(issueId)", "milestone", "\(milestoneId)"
        ])
        .map { [weak self] in
            self?.responseModel.getMessageResponse(from: $0)
        }
    }
    
    func requestInfoViaURL(urlString: String, body: Any? = nil) -> Observable<Data> {
        guard let url = URL(string: urlString) else {
            return Observable.create { observer in
                let disposables = Disposables.create()
                observer.onError(IssueDetailError.urlError)
                observer.onCompleted()
                return disposables
            }
        }
        
        return requestObservable(URLRequest(url: url))
    }
    
    struct Content {
        let date: Date
        let contents: String
        let assignee: IssueAssignee?
        let author: IssueListAuthor?
        let cellType: IssueDetailCellType
        let profileImage: String
    }
}

extension Array where Element == EmojiResponse {
    func getEncodedEmojis() -> [String] {
        
        let emojis = self.reduce([String]()) { partialResult, emojiInfo in
            let emojis = emojiInfo.unicode.split(separator: " ").map({String($0)})
            return partialResult + emojis.filter({$0.isEmpty == false})
        }
        
        return emojis.compactMap { emoji in
            guard let hexValue = Int(emoji.replacingOccurrences(of: "U+", with: ""), radix: 16), let unicodeScalar = UnicodeScalar(hexValue), unicodeScalar.value >= 100000 else {
                return nil
            }
            
            let result = String(unicodeScalar)
            return result.isEmpty ? nil : result
        }
    }
}

struct StatusEncodable: Encodable {
    let status: Bool
    let ids: [Int]
}

struct EmojiResponse: Decodable {
    let name: String
    let unicode: String
}

private struct PrivateParameter {
    let memberId: Int
    let issueId: Int
    let token: String
}

private extension IssueHistories {
    func getContents() -> IssueDetailViewModel.Content {
        let date = DateFormatter().date(from: modifiedAt) ?? Date()
        return IssueDetailViewModel.Content(
            date: date,
            contents: action,
            assignee: assignee,
            author: nil,
            cellType: .separator,
            profileImage: assignee?.profileImage ?? ""
        )
    }
}

private extension IssueListComment {
    func getContents() -> IssueDetailViewModel.Content {
        let date = DateFormatter().date(from: createdAt ?? "") ?? Date()
        return IssueDetailViewModel.Content(
            date: date,
            contents: content,
            assignee: nil,
            author: author,
            cellType: .info,
            profileImage: author.profileImage
        )
    }
}
