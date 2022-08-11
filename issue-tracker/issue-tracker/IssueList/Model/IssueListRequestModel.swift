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
    
    private var requestModelData: ((IssueListParameter, AnyObserver<Data>) -> Void)?
    
    typealias ReactiveResult = Data
    typealias RequestParameter = IssueListParameter
    
    private(set) var issueList = [IssueListEntity]()
    private var disposeBag = DisposeBag()
    
    var binding: ViewBinding?
    
    func requestModelData(_ parameter: RequestParameter, _ observer: AnyObserver<Data>) {
        for queryString in parameter.queryString {
            requestBuilder.setPath(queryString)
        }
        
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: DispatchTime.now()+Double.random(in: 1.5...2.0)) {
            if let issueListData = try? JSONEncoder().encode(Array(repeating: IssueListEntity.mockData(), count: Int.random(in: 1...8))) {
                observer.onNext(issueListData)
            } else {
                observer.onNext(Data())
            }
            observer.onCompleted()
        }
        
//        request { result, response in
//            switch result {
//            case .success(let data):
//                observer.onNext(data)
//            case .failure(let error):
//                observer.onError(error)
//            }
//            
//            observer.onCompleted()
//        }
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

private extension IssueListEntity {
    static func mockData() -> IssueListEntity {
        IssueListEntity(key: UUID(), title: "title text in mock", contents: "contentscontentscontentscontentscontentscontentscontentscontentscontentscontentscontentscontentscontents")
    }
}

struct IssueListParameter: Encodable {
    let queryString: [String]
}
