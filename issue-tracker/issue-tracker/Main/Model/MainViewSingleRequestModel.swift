//
//  MainViewSingleRequestModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/31.
//

import RxSwift

/// MainView에서 List 가 아닌 데이터를 호출하고 관리함.
final class MainViewSingleRequestModel<ResultType: Decodable>: RequestHTTPModel, ViewBindable {
    
    typealias ReactiveResult = Data
    typealias Entity = ResultType
    
    private(set) var entity: Entity?
    private var disposeBag = DisposeBag()
    
    var nextHandler: ((Entity?) -> Void)?
    var errorHandler: ((Error?) -> Void)?
    var binding: ViewBinding?
    
    func requestIssueList(requestHandler: ((Entity?) -> Void)? = nil) {
        requestObservable()
            .subscribe(
                onNext: { [weak self] data in
                    guard let self = self else { return }
                    
                    let entity = HTTPResponseModel().getDecoded(from: data, as: Entity.self)
                    
                    self.entity = entity
                    self.nextHandler?(entity)
                    requestHandler?(entity)
                },
                onError: errorHandler
            )
            .disposed(by: disposeBag)
    }
}