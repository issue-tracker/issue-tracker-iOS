//
//  IssueDetailViewModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/13.
//

import Foundation
import RxSwift

enum IssueDetailError: Error {
    case iDError
    case memberIdError
    case tokenUnavailableError
    case responseWithError
}

enum IssueDetailCellType {
    case separator
    case info
}

// RequestHTTPModel 을 상속하는 이유는 여러가지의 response 가 있을 수 있기 때문.
// 다양한 HTTP Response Body 에 대응해야 한다.
class IssueDetailViewModel: RequestHTTPModel, ViewBindable {
    
    private var bagCount = 0
    /// Model 에서 DisposeBag 을 관리하는 이유는 효율적인 메모리 관리(4 번 이상의 리퀘스트 이후에는 DisposeBag 을 초기화 ) 를 위함입니다.
    ///
    /// Model 의 DisposeBag 을 이용하시는 것을 권해드립니다.
    var bag = DisposeBag() {
        didSet {
            bagCount += 1
            if bagCount >= 4 {
                bag = DisposeBag()
            }
        }
    }
    
    private var responseModel: HTTPResponseModel {
        return HTTPResponseModel()
    }
    private var issueId: Int = -1
    
    var binding: ViewBinding?
    
    // Entities for DetailView
    var issueDetail: IssueListEntity?
    
    var commentsOfIssue: [IssueListComment]? { issueDetail?.comments }
    var authorInfo: IssueListAuthor? { issueDetail?.author }
    var assigneeInfo: [IssueAssignee]? { issueDetail?.issueAssignees }
    var labelsInfo: [LabelListEntity]? { issueDetail?.issueLabels }
    var milestoneInfo: MilestoneListEntity? { issueDetail?.milestone }
    
    override init(_ baseURL: URL) {
        super.init(baseURL)
    }
    
    convenience init?(issueId: Int) {
        if let url = URL.issueApiURL {
            self.init(url)
        } else {
            return nil
        }
        
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
            
            return Observable.just(self.responseModel.getDecoded(from: data, as: T.self))
        }
    }
    
    private func getParameter() throws -> PrivateParameter {
        guard let memberId = UserDefaults.standard.object(forKey: "memberId") as? Int else {
            throw IssueDetailError.memberIdError
        }
        guard issueId > 0 else {
            throw IssueDetailError.iDError
        }
        guard let token = UserDefaults.standard.value(forKey: "accessToken") as? String else {
            throw IssueDetailError.tokenUnavailableError
        }
        
        return PrivateParameter(memberId: memberId, issueId: issueId, token: token)
    }
    
    // MARK: - APIs
    func getDetailEntity() throws -> Observable<IssueListEntity?> {
        let param = try getParameter()
        builder.setHeader(key: "Authorization", value: "Bearer " + param.token)
        return responseFlatten(requestObservable(pathArray: ["\(issueId)"]))
    }
    
    func getCellEntity(_ indexPath: IndexPath) -> IssueListComment? {
        let floatIndex = ceil(Float(indexPath.row/2))
        return commentsOfIssue?[Int(floatIndex)]
    }
    
    func getCellType(_ indexPath: IndexPath) -> IssueDetailCellType {
        indexPath.row.isMultiple(of: 2) ? .separator : .info
    }
    
    // title, status, emojis
    func setTitle(_ title: String) throws -> Observable<IssueListEntity?> {
        let param = try getParameter()
        builder.setHeader(key: "Authorization", value: "Bearer " + param.token)
        builder.setURLQuery(["memberId": "\(param.memberId)"])
        builder.setBody( ["id": param.issueId] )
        
        return responseFlatten(requestObservable(pathArray: [
            "\(issueId)",
            "title"
        ]))
    }
    
    func setStatus(_ status: Bool) throws -> Observable<IssueListEntity?> {
        let param = try getParameter()
        builder.setHeader(key: "Authorization", value: "Bearer " + param.token)
        builder.setURLQuery(["memberId": "\(param.memberId)"])
        builder.setBody(StatusEncodable(status: status, ids: [param.issueId]))
        
        return responseFlatten(requestObservable(pathArray: ["update-status"]))
    }
    
    func getEmojis() throws -> Observable<[EmojiResponse]?> {
        responseFlatten(requestObservable(pathArray: [
            "comments",
            "reactions",
            "emojis"
        ]))
    }
    
    // label
    func setLabel(_ labelId: Int) throws -> Observable<IssueListEntity?> {
        let param = try getParameter()
        builder.setHeader(key: "Authorization", value: "Bearer " + param.token)
        builder.setURLQuery(["memberId": "\(param.memberId)"])
        
        return responseFlatten(requestObservable(pathArray: [
            "\(param.issueId)",
            "labels",
            "\(labelId)"
        ]))
    }
    
    func deleteLabel(_ labelId: Int) throws -> Observable<String?> {
        let param = try getParameter()
        builder.setHeader(key: "Authorization", value: "Bearer " + param.token)
        builder.setURLQuery(["memberId": "\(param.memberId)"])
        
        return requestObservable(pathArray: [
            "\(param.issueId)",
            "\(labelId)"
        ]).map { [weak self] in self?.responseModel.getMessageResponse(from: $0) }
    }
    
    // comment
    func setComment(_ content: String) throws -> Observable<IssueListEntity?> {
        let param = try getParameter()
        builder.setHeader(key: "Authorization", value: "Bearer " + param.token)
        builder.setURLQuery(["memberId": "\(param.memberId)"])
        builder.setBody(["content": content])
        
        return responseFlatten(requestObservable(pathArray: [
            "\(param.issueId)",
            "comments"
        ]))
    }
    
    func deleteComment(_ commentId: Int) throws -> Observable<String?> {
        let param = try getParameter()
        builder.setHeader(key: "Authorization", value: "Bearer " + param.token)
        builder.setURLQuery(["memberId": "\(param.memberId)"])
        
        return requestObservable(pathArray: [
            "\(issueId)",
            "comments",
            "\(commentId)"
        ]).map { [weak self] in self?.responseModel.getMessageResponse(from: $0) }
    }
    
    func updateComment(_ commentId: Int, content: String) throws -> Observable<IssueListEntity?> {
        let param = try getParameter()
        builder.setHeader(key: "Authorization", value: "Bearer " + param.token)
        builder.setURLQuery(["memberId": "\(param.memberId)"])
        builder.setBody(["content": content])
        
        return responseFlatten(requestObservable(pathArray: [
            "\(issueId)",
            "comments",
            "\(commentId)"
        ]))
    }
    
    func setReactionTo(commentId: Int, emojiName: String) throws -> Observable<IssueListEntity?> {
        let param = try getParameter()
        builder.setHeader(key: "Authorization", value: "Bearer " + param.token)
        builder.setURLQuery(["memberId": "\(param.memberId)"])
        
        return responseFlatten(requestObservable(pathArray: [
            "\(issueId)",
            "comments",
            "\(commentId)",
            "reactions",
            "\(emojiName)"
        ]))
    }
    
    func deleteReactionTo(commentId: Int, reactionId: Int) throws -> Observable<String?> {
        let param = try getParameter()
        builder.setHeader(key: "Authorization", value: "Bearer " + param.token)
        builder.setURLQuery(["memberId": "\(param.memberId)"])
        
        return requestObservable(pathArray: [
            "\(issueId)",
            "comments",
            "\(commentId)",
            "reactions",
            "\(reactionId)"
        ]).map { [weak self] in self?.responseModel.getMessageResponse(from: $0) }
    }
    
    // assignee
    func setAssignee(_ assigneeId: Int) throws -> Observable<IssueListEntity?> {
        let param = try getParameter()
        builder.setHeader(key: "Authorization", value: "Bearer " + param.token)
        builder.setURLQuery(["memberId":"\(param.memberId)"])
        
        return responseFlatten(requestObservable(pathArray: [
            "\(param.issueId)",
            "assignees","\(assigneeId)"
        ]))
    }
    
    func deleteAssignee(_ assigneeId: Int) throws -> Observable<String?> {
        let param = try getParameter()
        builder.setHeader(key: "Authorization", value: "Bearer " + param.token)
        builder.setURLQuery([
            "memberId": "\(param.memberId)",
            "assigneeId": "\(assigneeId)",
            "issueId": "\(param.issueId)"
        ])
        
        return requestObservable(pathArray: [
            "\(param.issueId)",
            "assignees"
        ]).map { [weak self] in self?.responseModel.getMessageResponse(from: $0) }
    }
    
    // milestone
    func setMilestone(_ milestoneId: Int) throws -> Observable<IssueListEntity?> {
        let param = try getParameter()
        builder.setHeader(key: "Authorization", value: "Bearer " + param.token)
        builder.setURLQuery(["memberId": "\(param.memberId)"])
        
        return responseFlatten(requestObservable(pathArray: [
            "\(issueId)",
            "milestone",
            "\(milestoneId)"
        ]))
    }
    
    func deleteMilestone(_ milestoneId: Int) throws -> Observable<String?> {
        let param = try getParameter()
        builder.setHeader(key: "Authorization", value: "Bearer " + param.token)
        builder.setURLQuery(["memberId": "\(param.memberId)"])
        
        return requestObservable(pathArray: [
            "\(issueId)",
            "milestone",
            "\(milestoneId)"
        ]).map { [weak self] in self?.responseModel.getMessageResponse(from: $0) }
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
