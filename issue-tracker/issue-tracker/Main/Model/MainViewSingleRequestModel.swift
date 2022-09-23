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
    
    private(set) var dataSource: PublishSubject<[ListType]>?
    
    private(set) var entity: Entity?
    private(set) var entityList: [ListType] = []
    
    private var pageCount = 0
    
    private(set) var disposeBag = DisposeBag()
    
    var nextHandler: ((Entity?) -> Void)?
    var errorHandler: ((Error?) -> Void)?
    var binding: ViewBinding?
    
    func requestEntityList(_ requestHandler: ((Entity?) -> Void)? = nil) -> Observable<[ListType]> {
        guard pageCount >= 0 else { return Observable.empty() }
        
        builder.setURLQuery(["page":"\(pageCount)"])
        return requestObservable()
            .do(onError: { [weak self] error in
                self?.pageCount = -1
            })
            .map ({ [weak self] data -> [ListType] in
                guard let self = self else {
                    requestHandler?(nil)
                    throw HTTPError.createRequestFailed
                }
                
                guard let entity = HTTPResponseModel().getDecoded(from: data, as: Entity.self) else {
                    requestHandler?(nil)
                    throw HTTPError.noData
                }
                
                self.pageCount += 1
                self.entity = entity
                
                if let entityList = (entity as? EntityContainsResultList)?.list as? [ListType] {
                    self.entityList.append(contentsOf: entityList)
                } else {
                    self.pageCount = -1
                }
                
                self.binding?.bindableHandler?(entity, self)
                self.nextHandler?(entity)
                requestHandler?(entity)
                
                return self.entityList
            })
    }
    
    func requestEntity(_ requestHandler: ((Entity?) -> Void)? = nil) -> Observable<Entity> {
        guard pageCount >= 0 else { return Observable.empty() }
        
        builder.setURLQuery(["page":"\(pageCount)"])
        return requestObservable()
            .do(onError: { [weak self] error in
                self?.pageCount = -1
            })
            .map ({ [weak self] data -> Entity in
                guard let self = self else {
                    requestHandler?(nil)
                    throw HTTPError.createRequestFailed
                }
                
                guard let entity = HTTPResponseModel().getDecoded(from: data, as: Entity.self) else {
                    requestHandler?(nil)
                    throw HTTPError.noData
                }
                
                self.pageCount += 1
                self.entity = entity
                
                if let entityList = (entity as? EntityContainsResultList)?.list as? [ListType] {
                    self.entityList.append(contentsOf: entityList)
                }
                
                self.binding?.bindableHandler?(entity, self)
                self.nextHandler?(entity)
                requestHandler?(entity)
                
                return entity
            })
    }
    
    func reloadEntities(reloadHandler: ((Entity?)->Void)? = nil) {
        guard pageCount >= 0 else { return }
        
        pageCount = 0
        builder.setURLQuery(["page":"\(pageCount)"])
        request() { [weak self] result, response in
            guard let self = self else {
                self?.pageCount = -1
                return
            }
            
            switch result {
            case .success(let data):
                
                let entity = HTTPResponseModel().getDecoded(from: data, as: Entity.self)
                self.entity = entity
                
                if let entityList = (entity as? EntityContainsResultList)?.list as? [ListType] {
                    self.entityList.append(contentsOf: entityList)
                }
                
                reloadHandler?(entity)
                
            case .failure(_):
                
                self.pageCount = -1
                reloadHandler?(nil)
            }
        }
    }
}
