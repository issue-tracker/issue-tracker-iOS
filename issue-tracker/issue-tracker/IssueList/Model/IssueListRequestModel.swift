//
//  IssueListRequestModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/11.
//

import RxSwift

final class IssueListRequestModel: RequestHTTPModel, ViewBindable {
    
    typealias ReactiveResult = Data
    
    private(set) var issueList = [IssueListEntity]()
    private var disposeBag = DisposeBag()
    
    lazy var nextHandler: ((Data) -> Void)? = { _ in }
    
    var errorHandler: ((Error) -> Void)?
    var completedHandler: (() -> Void)?
    var disposeHandler: (() -> Void)?
    var binding: ViewBinding?
    
    func requestIssueList() { }
}

extension IssueListRequestModel: Testable {
    func doTest(_ param: Any?) { }
}

// 👺
struct IssueListParameter: Encodable {
    let queryString: [String]
}
