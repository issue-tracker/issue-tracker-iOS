//
//  MilestoneListReactor.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/08.
//

import Foundation
import ReactorKit

final class MilestoneListReactor: MainListStatusReactor {
    
    private(set) var model: MilestoneRequestListService? = nil
    init() {
        if let url = URL.issueApiURL {
            model = MilestoneRequestListService(url)
        }
    }
    
    var initialState: State = .init()
    
    enum Action {
        case reloadMilestone
        case itemSelected(IndexPath)
        case requestNextPage(IndexPath)
        case didScroll
    }
    
    enum Mutation {
        case reloadComplete(AllMilestoneEntity)
        case requestNextPageComplete(AllMilestoneEntity)
        case resignSearchBarResponder
    }
    
    struct State {
        var openMilestoneCount = 0
        var closedMilestoneCount = 0
        var pageNumber = 0
        var lockReload = false
        
        @Pulse var milestoneStatus: String = "0"
        @Pulse var milestones: [MilestoneListEntity] = []
        @Pulse var isRefreshing: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        guard let model else { return Observable.error(MainListReactorError.modelURLError) }
        
        switch action {
        case .reloadMilestone:
            return model.reloadEntities().map({ entity in Mutation.reloadComplete(entity) })
        case .itemSelected(_):
            return Observable.empty()
        case .requestNextPage(let indexPath):
            guard indexPath.row >= currentState.milestones.count - 3 else {
                return Observable.error(MainListReactorError.notMuchIndexForNextPage)
            }
            return model.requestEntity(currentState.pageNumber+1).map({ entity in Mutation.requestNextPageComplete(entity) })
        case .didScroll:
            return Observable.just(Mutation.resignSearchBarResponder)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        if case let .reloadComplete(entity) = mutation {
            newState.pageNumber = 1
            newState.milestones = entity.openedMilestones + entity.closedMilestones
            newState.lockReload = false
            newState.milestoneStatus = "\(entity.openedMilestones.count)/\(entity.openedMilestones.count+entity.closedMilestones.count)"
        } else if case let .requestNextPageComplete(entity) = mutation {
            newState.pageNumber += 1
            newState.milestones.append(contentsOf: entity.openedMilestones + entity.closedMilestones)
            newState.milestoneStatus = "\(entity.openedMilestones.count)/\(entity.openedMilestones.count+entity.closedMilestones.count)"
            newState.lockReload = entity.openedMilestones.isEmpty && entity.closedMilestones.isEmpty
        }
        
        return newState
    }
    
    func requestInitialList() {
        action.onNext(Action.reloadMilestone)
    }
    
    var mainListStatus: String {
        currentState.milestoneStatus
    }
}

final class MilestoneRequestListService: RequestHTTPModel {
    func reloadEntities() -> Observable<AllMilestoneEntity> {
        builder.setURLQuery(["page": "0"])
        return requestObservable()
            .flatMap({ data -> Observable<AllMilestoneEntity> in
                guard let result = HTTPResponseModel().getDecoded(from: data, as: AllMilestoneEntity.self) else {
                    return Observable.error(MainListReactorError.decodeAllIssueEntity("reloadEntities"))
                }
                
                return Observable.just(result)
            })
    }
    
    func requestEntity(_ pageNumber: Int = 0) -> Observable<AllMilestoneEntity> {
        builder.setURLQuery(["page": "\(pageNumber)"])
        return requestObservable()
            .flatMap({ data -> Observable<AllMilestoneEntity> in
                guard let result = HTTPResponseModel().getDecoded(from: data, as: AllMilestoneEntity.self) else {
                    return Observable.error(MainListReactorError.decodeAllIssueEntity("requestEntity"))
                }
                return Observable.just(result)
            })
            
    }
}
