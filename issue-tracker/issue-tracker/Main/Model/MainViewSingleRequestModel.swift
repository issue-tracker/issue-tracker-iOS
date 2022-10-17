//
//  MainViewSingleRequestModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/31.
//

import RxSwift
import RxCocoa
import Foundation

/// MainView에서 List 가 아닌 데이터를 호출하고 관리함.
final class MainViewSingleRequestModel<ResponseType: Decodable, ResponseEntityType: Decodable>: RequestHTTPModel, ViewBindable {
    
    typealias ListType = ResponseEntityType
    typealias Entity = ResponseType
    
    private(set) var dataSource = PublishSubject<[ListType]>()
    
    private(set) var entity: Entity?
    private(set) var entityList: [ListType] = []
    
    private var pageCount = 0
    
    private(set) var disposeBag = DisposeBag()
    
    var nextHandler: ((Entity?) -> Void)?
    var errorHandler: ((Error?) -> Void)?
    var binding: ViewBinding?
    
    var issueQueryPath: String?
    private var urlContextPath = [String: String]()
    
    func requestEntity(_ requestHandler: ((Entity?) -> Void)? = nil) {
        guard pageCount >= 0 else { return }
        
        urlContextPath = ["page":"\(pageCount)"]
        if let issueQueryPath = issueQueryPath {
            urlContextPath["q"] = issueQueryPath
        }
        builder.setURLQuery(urlContextPath)
        
        defer {
            issueQueryPath = nil
            urlContextPath.removeAll()
        }
        
        requestObservable()
            .map ({ data -> Entity in
                guard let entity = HTTPResponseModel().getDecoded(from: data, as: Entity.self) else {
                    throw HTTPError.noData
                }
                
                return entity
            })
            .subscribe(onNext: { [weak self] entity in
                guard let self = self else { return }
                
                self.pageCount += 1
                self.entity = entity
                
                if let entityList = (entity as? EntityContainsResultList)?.list as? [ListType] {
                    self.entityList.append(contentsOf: entityList)
                }
                
                self.binding?.bindableHandler?(entity, self)
                self.nextHandler?(entity)
                requestHandler?(entity)
                self.dataSource.onNext(self.entityList)
            })
            .disposed(by: disposeBag)
    }
    
    func reloadEntities(reloadHandler: ((Entity?)->Void)? = nil) {
        guard pageCount >= 0 else { return }
        
        pageCount = 0
        
        urlContextPath = ["page":"\(pageCount)"]
        if let issueQueryPath = issueQueryPath {
            urlContextPath["q"] = issueQueryPath
        }
        builder.setURLQuery(urlContextPath)
        
        defer {
            issueQueryPath = nil
            urlContextPath.removeAll()
        }
        
        request() { [weak self] result, response in
            guard let self = self else {
                self?.pageCount = -1
                return
            }
            
            switch result {
            case .success(let data):
//                print(String(data: data, encoding: .utf8))
//                print(response?.url?.absoluteString)
                let entity = HTTPResponseModel().getDecoded(from: data, as: Entity.self)
                self.entity = entity
                
                let entityList = (entity as? EntityContainsResultList)?.list as? [ListType]
                self.entityList = entityList ?? []
                self.dataSource.onNext(self.entityList)
                
                reloadHandler?(entity)
                
            case .failure(_):
                
                self.pageCount = -1
                reloadHandler?(nil)
            }
        }
    }
}
