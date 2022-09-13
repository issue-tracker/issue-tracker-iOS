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
        guard let memberId = UserDefaults.standard.object(forKey: "memberId") as? Int else {
            return Observable.just(nil)
        }
        
        builder.setURLQuery(["memberId": "\(memberId)"])
        builder.setBody(param)
        
        return requestObservable()
            .map { HTTPResponseModel().getDecoded(from: $0, as: IssueListEntity.self) }
    }
    
    func removeIssue(_ issueId: Int) -> Observable<String?> {
        guard let memberId = UserDefaults.standard.object(forKey: "memberId") as? Int else {
            return Observable.just(nil)
        }
        
        builder.setURLQuery(["memberId": "\(memberId)"])
        
        return requestObservable(pathArray: ["\(issueId)"])
            .map { HTTPResponseModel().getMessageResponse(from: $0) }
    }
}

struct IssueAddParameter: Encodable {
    let title: String
    let comment: String
    var assigneeIds = [Int]()
    var labelIds = [Int]()
    let milestoneId: Int
}
