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
    case iDError, memberIdError, tokenUnavailableError, responseWithError, urlError, errorOnBody
    case errorSpecified(String)
}

enum IssueDetailCellType {
    case separator, info
}

// RequestHTTPModel 을 상속하는 이유는 여러가지의 response 가 있을 수 있기 때문.
// 다양한 HTTP Response Body 에 대응해야 한다.
class IssueDetailViewModel: RequestHTTPModel {
    
    private var issueId: Int = -1
    private(set) var bag = DisposeBag()
    private var responseModel = HTTPResponseModel()
    
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
    
    private(set) var emojis: [String] = []
    
    override init(_ baseURL: URL) {
        super.init(baseURL)
    }
    
    convenience init?(issueId: Int) throws {
        guard let url = URL.issueApiURL, issueId > 0 else {
            return nil
        }
        
        self.init(url)
        self.issueId = issueId
    }
    
    // MARK: - Utils
    
    private func responseFlatten<T: Decodable>(_ observable: Observable<Data>) -> Observable<T?> {
        observable.flatMap { [weak self] data -> Observable<T?> in
            guard let self = self else { return Observable.never() }
            
            if let message = self.responseModel.getMessageResponse(from: data) {
                return Observable.error(IssueDetailError.errorSpecified(message))
            }
            
            return Observable.just(self.responseModel.getDecoded(from: data, as: T.self))
        }
    }
    // TODO: Comments first 는 맨 위의 메인 컨텐츠로 만들기.
    private func setissueContents() {
        // comments 는 있어야 Main Contents를 추가할 수 있음.
        guard var issueDetailComments = issueDetail?.comments, issueDetailComments.count >= 1 else { return }
        
        issueDetailComments.sort(by: { self.constructDate(from: $0.createdAt) < self.constructDate(from: $1.createdAt) })
        self.issueContents = issueDetailComments.removeFirst().getContents()
        
        let comparableItems: [Any] = (issueDetail?.issueHistories ?? []) + issueDetailComments
        self.issueSubContents = comparableItems.compactMap { item in
            (item as? IssueHistories)?.getContents() ?? (item as? IssueListComment)?.getContents()
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
            .do { entity in
                self.issueDetail = entity
                self.setissueContents()
            }
    }
    
    func getCellEntity(_ indexPath: IndexPath) -> Content? {
        indexPath.row == 0 ? issueContents : issueSubContents[indexPath.row-1]
    }
    
    func getCellHeight(_ indexPath: IndexPath) -> Float {
        guard indexPath.row != 0 else {
            return 300
        }
        
        let cellType = getCellEntity(indexPath)?.cellType ?? IssueDetailCellType.info
        return cellType == .separator ? 30 : 120
    }
    
    // MARK: issue title/status
    func setTitle(_ title: String) -> Observable<IssueListEntity?> {
        builder.setBody( ["id": self.issueId] )
        return responseFlatten(requestObservable(pathArray: [ "\(issueId)", "title" ]))
    }
    
    func setStatus(_ status: Bool) -> Observable<IssueListEntity?> {
        guard let body = try? JSONSerialization.data(withJSONObject: ["status": status, "ids": [issueId]], options: .prettyPrinted) else {
            return Observable.error(IssueDetailError.errorOnBody)
        }
        
        builder.setHTTPMethod("patch")
        builder.setBody(body)
        return responseFlatten(requestObservable(pathArray: ["update-status"]))
    }
    
    // MARK: emojis
    func getEmojis() {
        requestObservable(pathArray: ["comments", "reactions", "emojis"])
            .map({self.responseModel.getDecoded(from: $0, as: [EmojiResponse].self)})
            .subscribe(onNext: { self.emojis = $0?.getEncodedEmojis() ?? [] })
            .disposed(by: bag)
    }
    
    // MARK: label
    func setLabel(_ labelId: Int) -> Observable<IssueListEntity?> {
        builder.setHTTPMethod("post")
        return responseFlatten(requestObservable(pathArray: [ "\(issueId)", "labels", "\(labelId)" ]))
    }
    
    func deleteLabel(_ labelId: Int) -> Observable<String?> {
        builder.setHTTPMethod("delete")
        return requestObservable(pathArray: [ "\(issueId)", "labels", "\(labelId)" ])
            .map { [weak self] in self?.responseModel.getMessageResponse(from: $0) }
    }
    
    // comment
    func setComment(_ content: String) -> Observable<IssueListEntity?> {
        builder.setBody(["content": content])
        return responseFlatten(requestObservable(pathArray: [ "\(issueId)", "comments" ]))
    }
    
    func deleteComment(_ commentId: Int) -> Observable<String?> {
        builder.setHTTPMethod("delete")
        return requestObservable(pathArray: [ "\(issueId)", "comments", "\(commentId)" ])
            .map { [weak self] in self?.responseModel.getMessageResponse(from: $0) }
    }
    
    func updateComment(_ commentId: Int, content: String) -> Observable<IssueListEntity?> {
        builder.setHTTPMethod("patch")
        builder.setBody(["content": content])
        return responseFlatten(requestObservable(pathArray: [ "\(issueId)", "comments", "\(commentId)" ]))
    }
    
    func setReactionTo(commentId: Int, emojiName: String) -> Observable<IssueListEntity?> {
        builder.setHTTPMethod("patch")
        return responseFlatten(requestObservable(pathArray: [ "\(issueId)", "comments", "\(commentId)", "reactions", "\(emojiName)" ]))
    }
    
    func deleteReactionTo(commentId: Int, reactionId: Int) -> Observable<String?> {
        builder.setHTTPMethod("delete")
        return requestObservable(pathArray: [ "\(issueId)", "comments", "\(commentId)", "reactions", "\(reactionId)" ])
            .map { [weak self] in self?.responseModel.getMessageResponse(from: $0) }
    }
    
    // assignee
    func setAssignee(_ assigneeId: Int) -> Observable<IssueListEntity?> {
        builder.setHTTPMethod("post")
        return responseFlatten(requestObservable(pathArray: [ "\(issueId)", "assignees","\(assigneeId)" ]))
    }
    
    func deleteAssignee(_ assigneeId: Int) -> Observable<String?> {
        builder.setHTTPMethod("delete")
        builder.setURLQuery([ "clear": "true", "assigneeId": "\(assigneeId)" ])
        return requestObservable(pathArray: [ "\(issueId)", "assignees" ])
            .map { [weak self] in self?.responseModel.getMessageResponse(from: $0) }
    }
    
    // MARK: milestone
    func setMilestone(_ milestoneId: Int) -> Observable<IssueListEntity?> {
        builder.setHTTPMethod("patch")
        return responseFlatten(requestObservable(pathArray: [ "\(issueId)", "milestone", "\(milestoneId)" ]))
    }
    
    func deleteMilestone(_ milestoneId: Int) -> Observable<String?> {
        builder.setHTTPMethod("delete")
        return requestObservable(pathArray: [ "\(issueId)", "milestone", "\(milestoneId)" ])
            .map { [weak self] in self?.responseModel.getMessageResponse(from: $0) }
    }
    
    struct Content {
        let date: Date
        let contents: String
        let assignee: IssueAssignee?
        let author: IssueListAuthor?
        let cellType: IssueDetailCellType
        let profileImage: String
        let reactions: [IssueCommentReactionsResponse]
    }
}

extension Array where Element == EmojiResponse {
    func getEncodedEmojis() -> [String] {
        
        let emojis = self.reduce([String]()) { partialResult, emojiInfo in
            let emojis = emojiInfo.unicode.split(separator: " ").map({String($0)})
            return partialResult + emojis.filter({$0.isEmpty == false})
        }
        
        return emojis.compactMap { $0.convertEmoji() }
    }
}

extension String {
    func convertEmoji() -> String? {
        guard let hexValue = Int(self.replacingOccurrences(of: "U+", with: ""), radix: 16), let unicodeScalar = UnicodeScalar(hexValue), unicodeScalar.value >= 100000 else {
            return nil
        }
        
        let emoji = String(unicodeScalar)
        return emoji.isEmpty ? nil : emoji
    }
}

struct EmojiResponse: Decodable {
    let name: String
    let unicode: String
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
            profileImage: assignee?.profileImage ?? "",
            reactions: []
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
            profileImage: author.profileImage,
            reactions: issueCommentReactionsResponse ?? []
        )
    }
}
