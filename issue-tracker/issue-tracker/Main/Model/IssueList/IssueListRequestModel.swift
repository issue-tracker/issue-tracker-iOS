//
//  IssueListRequestModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/11.
//

import RxSwift

final class IssueListRequestModel: RequestHTTPModel, ViewBindable {
    
    typealias ReactiveResult = Data
    
    private(set) var issueList: [IssueListEntity] = []
    private var disposeBag = DisposeBag()
    
    var nextHandler: ((Int, [IssueListEntity]?) -> Void)?
    var errorHandler: ((Error?) -> Void)?
    var binding: ViewBinding?
    
    func requestIssueList(_ pageNumber: UInt = 0, requestHandler: ((Int, [IssueListEntity]?) -> Void)? = nil) {
        let pageNumberInteger = Int(pageNumber)
        let pathArray = ["\(pageNumberInteger)"]
        requestObservable(pathArray: pathArray)
            .subscribe(
                onNext: { [weak self] data in
                    guard
                        let self = self,
                        let list = HTTPResponseModel().getDecoded(from: data, as: [IssueListEntity].self)
                    else {
                        return
                    }
                    
                    self.issueList.append(contentsOf: list)
                    if let requestHandler = requestHandler {
                        requestHandler(Int(pageNumber), list)
                    } else {
                        self.nextHandler?(Int(pageNumber), list)
                    }
                },
                onError: errorHandler
            )
            .disposed(by: disposeBag)
    }
    
    func reloadIssueList(reloadHandler: (([IssueListEntity]?)->Void)? = nil) {
        request(pathArray: []) { result, response in
            reloadHandler?(HTTPResponseModel().getDecoded(from: result, as: [IssueListEntity].self))
        }
    }
}
