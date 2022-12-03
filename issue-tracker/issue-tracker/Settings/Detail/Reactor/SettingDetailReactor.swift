//
//  SettingDetailReactor.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/12/02.
//

import Foundation
import ReactorKit

class SettingDetailReactor: Reactor {
    
    var initialState: State = .init()
    
    struct State {
        
    }
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        return initialState
    }
}
