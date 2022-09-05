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
    
    func requestIssueList(_ pageNumber: UInt? = nil, requestHandler: ((Int, [Entity]?) -> Void)? = nil) {
        var pathArray = [String]()
        if let pageNumber = pageNumber {
            pathArray.append("\(pageNumber)")
        }
        
        requestObservable(pathArray: pathArray)
            .subscribe(
                onNext: { [weak self] data in
                    guard let self = self else { return }
                    
                    let list = HTTPResponseModel().getDecoded(from: data, as: [Entity].self) ?? []
                    
                    self.entityList.append(contentsOf: list)
                    self.binding?.bindableHandler?(self.entityList, self) // ViewController 에 정의된 클로저.
                    self.nextHandler?(Int(pageNumber ?? 0), list) // ViewController 가 주입하는 클로저.
                    requestHandler?(Int(pageNumber ?? 0), list) // ViewController 가 reuqestIssueList 호출 시 파라미터로 전달한 클로저.
                },
                onError: errorHandler
            )
            .disposed(by: disposeBag)
    }
    
    func reloadIssueList(reloadHandler: (([Entity]?)->Void)? = nil) {
        request(pathArray: []) { [weak self] result, response in
            guard let self = self else { return }
            
            let list = HTTPResponseModel().getDecoded(from: result, as: [Entity].self)
            
            self.entityList = list ?? []
            reloadHandler?(list)
        }
    }
}
