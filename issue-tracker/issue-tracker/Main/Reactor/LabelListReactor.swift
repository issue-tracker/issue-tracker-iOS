//
//  LabelListReactor.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/08.
//

import Foundation
import ReactorKit

final class LabelListReactor: MainListStatusReactor {
    
    private(set) var model: LabelRequestListService? = nil
    init() {
        if let url = URL.labelApiURL {
            model = LabelRequestListService(url)
        }
    }
    
    var initialState: State = .init()
    
    enum Action {
        case reloadLabel
        case itemSelected(IndexPath)
        case requestNextPage(IndexPath)
        case didScroll
    }

    enum Mutation {
        case reloadComplete([LabelListEntity])
        case requestNextPageComplete([LabelListEntity])
        case resignSearchBarResponse
    }

    struct State {
        var openLabelCount = 0
        var closedLabelCount = 0
        var pageNumber = 0
        var lockReload = false
        @Pulse var labelStatus: String = "0"
        @Pulse var labels: [LabelListEntity] = []
        @Pulse var isRefreshing: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        guard let model else { return Observable.error(MainListReactorError.modelURLError) }
        
        switch action {
        case .reloadLabel:
            return model.reloadEntities().map({ entity in Mutation.reloadComplete(entity) })
        case .itemSelected(_):
            return Observable.empty()
        case .requestNextPage(let indexPath):
            guard indexPath.row >= currentState.labels.count - 3 else {
                return Observable.error(MainListReactorError.notMuchIndexForNextPage)
            }
            
            return model.requestEntity(currentState.pageNumber+1)
                .map({ entity in Mutation.requestNextPageComplete(entity) })
            
        case .didScroll:
            return Observable.just(Mutation.resignSearchBarResponse)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        if case let .reloadComplete(entity) = mutation {
            newState.pageNumber = 1
            newState.labels = entity
            newState.lockReload = false
            newState.labelStatus = "\(newState.labels.count)"
        } else if case let .requestNextPageComplete(entity) = mutation {
            newState.pageNumber += 1
            newState.labels.append(contentsOf: entity)
            newState.labelStatus = "\(newState.labels.count)"
            newState.lockReload = entity.isEmpty
        }
        
        return newState
    }
    
    func requestInitialList() {
        action.onNext(Action.reloadLabel)
    }
    
    var mainListStatus: String {
        currentState.labelStatus
    }
}

final class LabelRequestListService: RequestHTTPModel {
    func reloadEntities() -> Observable<[LabelListEntity]> {
        builder.setURLQuery(["page": "0"])
        return requestObservable()
            .flatMap({ data -> Observable<[LabelListEntity]> in
                guard let result = HTTPResponseModel().getDecoded(from: data, as: [LabelListEntity].self) else {
                    return Observable.error(MainListReactorError.decodeAllIssueEntity("reloadEntities"))
                }
                
                return Observable.just(result)
            })
    }
    
    func requestEntity(_ pageNumber: Int = 0) -> Observable<[LabelListEntity]> {
        builder.setURLQuery(["page": "\(pageNumber)"])
        return requestObservable()
            .flatMap({ data -> Observable<[LabelListEntity]> in
                guard let result = HTTPResponseModel().getDecoded(from: data, as: [LabelListEntity].self) else {
                    return Observable.error(MainListReactorError.decodeAllIssueEntity("requestEntity"))
                }
                return Observable.just(result)
            })
            
    }
}
