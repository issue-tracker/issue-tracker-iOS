//
//  ModelTestableReactively.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/10.
//

import RxSwift

protocol ModelTestableReactively: ModelProducingObservable {
    var disposables: [Disposable] { get set }
    var disposableLimitCount: Int { get }
    var disposeBag: DisposeBag { get set }
    func doTest(_ param: RequestParameter?)
}

extension ModelTestableReactively {
    
    func setDisposableCount(_ disposable: Disposable) {
        disposables.append(disposable)
        disposable.disposed(by: disposeBag)
        
        if disposables.count > disposableLimitCount {
            disposeBag = DisposeBag()
        }
    }
}
