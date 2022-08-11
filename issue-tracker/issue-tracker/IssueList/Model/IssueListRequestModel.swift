//
//  IssueListRequestModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/11.
//

import RxSwift

final class IssueListRequestModel: RequestHTTPModel, ModelProducingObservable, ViewBindable {
    
    lazy var nextHandler: ((Data) -> Void)? = { data in
        guard
            let viewController = self.binding as? IssueListViewController,
            let resultList = try? JSONDecoder().decode(Array<IssueListEntity>.self, from: data)
        else {
            return
        }
        
        self.issueList = resultList
        self.binding?.bindableHandler?(resultList, self)
    }
    
    var errorHandler: ((Error) -> Void)?
    var completedHandler: (() -> Void)?
    var disposeHandler: (() -> Void)?
    
    var requestModelData: ((IssueListParameter, AnyObserver<Data>) -> Void)?
    
    typealias ReactiveResult = Data
    typealias RequestParameter = IssueListParameter
    
    var issueList = [IssueListEntity]()
    var disposeBag = DisposeBag()
    
    var binding: ViewBinding?
    
    func requestModelData(_ parameter: RequestParameter, _ observer: AnyObserver<Data>) {
        for queryString in parameter.queryString {
            requestBuilder.setPath(queryString)
        }
        
        request { result, response in
            switch result {
            case .success(let data):
                observer.onNext(data)
            case .failure(let error):
                observer.onError(error)
            }
            observer.onCompleted()
        }
    }
    
    func requestIssueList() {
        let param = IssueListParameter(queryString: ["test"])
        requestReactive(param).disposed(by: disposeBag)
    }
}

extension IssueListRequestModel: Testable {
    func doTest(_ param: Any?) {
        
    }
}

struct IssueListEntity: Decodable {
    let key: UUID
}

struct IssueListParameter: Encodable {
    let queryString: [String]
}
