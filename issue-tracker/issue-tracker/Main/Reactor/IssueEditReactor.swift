//
//  IssueEditReactor.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/07.
//

import Foundation
import ReactorKit

enum AddIssueError: Error {
    case editScreenStateNotEnabled
    case parameterNull
}

final class IssueEditReactor: Reactor {
    
    init() {
        if let url = URL.issueApiURL {
            model = IssueAddRemoveModel(url)
        }
    }
    
    // MARK: - Model(s)
    let id = UserDefaults.standard.value(forKey: "memberId") as? Int
    private var model: IssueAddRemoveModel? = nil
    
    // MARK: - Action, Mutation, State types
    enum Action {
        case titleChanged(String?)
        case contentsChanged(String?)
        case submit
    }
    
    enum Mutation {
        case setRightBarButtonState(Bool)
        case submitComplete(Bool)
    }
    
    struct State {
        var title: String = ""
        var contents: String = ""
        @Pulse var rightBarButtonState: Bool = false
        var submitResult: Bool = false
        
        func isEmpty() -> Bool {
            title.isEmpty && contents.isEmpty
        }
    }
    
    var initialState: State = State()
    
    // MARK: - mutate, reduce
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .titleChanged(let str), .contentsChanged(let str):
            return Observable.deferred {
                if let str {
                    return Observable.just(Mutation.setRightBarButtonState(str.isEmpty == false))
                } else {
                    return Observable.error(AddIssueError.parameterNull)
                }
            }
        case Action.submit:
            guard initialState.isEmpty() == false, let model, let id else {
                return Observable.error(AddIssueError.editScreenStateNotEnabled)
            }
            
            let result = model.addIssue(IssueAddParameter(
                title: initialState.title,
                comment: initialState.contents,
                assigneeIds: [id],
                labelIds: [1,2,3,4],
                milestoneId: 1
            ))
            
            return result.map { entity in
                Mutation.submitComplete(entity?.isEmptyContents() ?? false)
            }
        }
    }
    
    func transform(action: Observable<Action>) -> Observable<Action> {
        return action.do(onNext: { action in
            switch action {
            case .titleChanged(let str):
                self.initialState.title = str ?? ""
            case .contentsChanged(let str):
                self.initialState.contents = str ?? ""
            default:
                return
            }
        })
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case Mutation.setRightBarButtonState(let buttonEnabled):
            newState.rightBarButtonState = buttonEnabled
            return newState
        case Mutation.submitComplete(let result):
            newState.submitResult = result
            return newState
        }
    }
}

private extension Optional where Wrapped == String {
    func isOptionalEmpty() -> Bool {
        guard let str = self else { return true }
        return str.isEmpty
    }
}
