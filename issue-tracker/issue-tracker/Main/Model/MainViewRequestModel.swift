//
//  IssueListRequestModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/11.
//

import RxSwift

/// MainView에서 List 형태의 데이터를 호출하고 관리함.
final class MainViewRequestModel<ResultType: Decodable>: RequestHTTPModel, ViewBindable {
    
    typealias ReactiveResult = Data
    typealias Entity = ResultType
    
    private(set) var entityList: [Entity] = []
    private var disposeBag = DisposeBag()
    
    var nextHandler: ((Int, [Entity]?) -> Void)?
    var errorHandler: ((Error?) -> Void)?
    var binding: ViewBinding?
    
    func requestIssueList(_ pageNumber: UInt = 0, requestHandler: ((Int, [Entity]?) -> Void)? = nil) {
        let pageNumberInteger = Int(pageNumber)
        let pathArray = ["\(pageNumberInteger)"]
        requestObservable(pathArray: pathArray)
            .subscribe(
                onNext: { [weak self] data in
                    guard let self = self else { return }
                    
                    let list = HTTPResponseModel().getDecoded(from: data, as: [Entity].self) ?? []
                    
                    self.entityList.append(contentsOf: list)
                    self.nextHandler?(Int(pageNumber), list)
                    requestHandler?(Int(pageNumber), list)
                },
                onError: errorHandler
            )
            .disposed(by: disposeBag)
    }
    
    func reloadIssueList(reloadHandler: (([Entity])->Void)? = nil) {
        request(pathArray: []) { [weak self] result, response in
            guard let self = self else { return }
            
            let list = HTTPResponseModel().getDecoded(from: result, as: [Entity].self) ?? []
            
            self.entityList = list
            reloadHandler?(list)
        }
    }
}
