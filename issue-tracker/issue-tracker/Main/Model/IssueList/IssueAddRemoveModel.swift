//
//  IssueAddRemoveModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/13.
//

import Foundation
import RxSwift

class IssueAddRemoveModel: RequestHTTPModel {
    
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
}

struct IssueAddParameter: Codable {
    let title: String
    let comment: String
    var assigneeIds = [Int]()
    var labelIds = [Int]()
    let milestoneId: Int?
}
