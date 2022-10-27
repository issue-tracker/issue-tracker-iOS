//
//  IssueAddRemoveModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/13.
//

import Foundation
import RxSwift

class IssueAddRemoveModel: RequestHTTPModel {
    
    func addIssue(_ param: IssueAddParameter) -> Observable<IssueListEntity?> {
        builder.setBody(param)
        builder.setHTTPMethod("post")
        
        return requestObservable()
            .map { HTTPResponseModel().getDecoded(from: $0, as: IssueListEntity.self) }
    }
    
    func removeIssue(_ issueId: Int) -> Observable<String?> {
        builder.setHTTPMethod("delete")
        
        return requestObservable(pathArray: ["\(issueId)"])
            .map { HTTPResponseModel().getMessageResponse(from: $0) }
    }
    
    func updateIssue(_ issueId: Int) -> Observable<String?> {
        builder.setHTTPMethod("delete")
        
        return requestObservable(pathArray: ["\(issueId)"])
            .map { HTTPResponseModel().getMessageResponse(from: $0) }
    }
}

struct IssueAddParameter: Codable {
    let title: String
    let comment: String
    var assigneeIds = [Int]()
    var labelIds = [Int]()
    let milestoneId: Int?
}
