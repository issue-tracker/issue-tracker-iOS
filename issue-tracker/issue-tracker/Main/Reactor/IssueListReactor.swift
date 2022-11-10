//
//  IssueListReactor.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/07.
//

import Foundation
import ReactorKit

protocol NormalState {
    var openIssueCount: Int { get set }
    var closedIssueCount: Int { get set }
    var pageNumber: Int { get set }
    
    var issueStatus: String { get set }
    var issues: [IssueListEntity] { get set }
    var lockReload: Bool { get set }
    var isRefreshing: Bool { get set }
}

final class IssueListReactor: MainListStatusReactor {
    
    private(set) var model: IssueRequestListService? = nil
    init() {
        if let url = URL.issueApiURL {
            model = IssueRequestListService(url)
        }
    }
    
    var initialState: State = State()
    
    enum Action {
        case reloadIssue
        case itemSelected(IndexPath)
        case requestNextPage(IndexPath)
        case didScroll
    }
    
    enum Mutation {
        case reloadComplete(AllIssueEntity)
        case requestNextPageComplete(AllIssueEntity)
        case resignSearchBarResponder
        case lockReload
    }
    
    struct State {
        var openIssueCount = 0
        var closedIssueCount = 0
        var pageNumber = 0
        
        @Pulse var issueStatus: String = "0/0"
        @Pulse var issues: [IssueListEntity] = []
        @Pulse var lockReload = false
        @Pulse var isRefreshing = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        guard let model else { return Observable.error(MainListReactorError.modelURLError) }
        
        switch action {
        case .reloadIssue:
            return model.reloadEntities().map({ entity in Mutation.reloadComplete(entity) })
        case .itemSelected(_):
            return Observable.empty()
        case .requestNextPage(let indexPath):
            guard indexPath.row >= currentState.issues.count - 3, currentState.lockReload == false else {
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
            newState.issues = entity.issues
            newState.issueStatus = "\(entity.openIssueCount)/\(entity.openIssueCount+entity.closedIssueCount)"
            newState.isRefreshing = false
        } else if case let .requestNextPageComplete(entity) = mutation {
            newState.pageNumber += 1
            newState.issues.append(contentsOf: entity.issues)
            newState.issueStatus = "\(entity.openIssueCount)/\(entity.openIssueCount+entity.closedIssueCount)"
            newState.lockReload = entity.issues.isEmpty
        }
        
        return newState
    }
    
    func requestInitialList() {
        action.onNext(Action.reloadIssue)
    }
    
    var mainListStatus: String {
        currentState.issueStatus
    }
}

final class IssueRequestListService: RequestHTTPModel {
    func reloadEntities() -> Observable<AllIssueEntity> {
        builder.setURLQuery(["page": "0"])
        return requestObservable()
            .flatMap({ data -> Observable<AllIssueEntity> in
                guard let result = HTTPResponseModel().getDecoded(from: data, as: AllIssueEntity.self) else {
                    return Observable.error(MainListReactorError.decodeAllIssueEntity("reloadEntities"))
                }
                
                return Observable.just(result)
            })
    }
    
    func requestEntity(_ pageNumber: Int = 0) -> Observable<AllIssueEntity> {
        builder.setURLQuery(["page": "\(pageNumber)"])
        return requestObservable()
            .flatMap({ data -> Observable<AllIssueEntity> in
                guard let result = HTTPResponseModel().getDecoded(from: data, as: AllIssueEntity.self) else {
                    return Observable.error(MainListReactorError.decodeAllIssueEntity("requestEntity"))
                }
                return Observable.just(result)
            })
    }
}
