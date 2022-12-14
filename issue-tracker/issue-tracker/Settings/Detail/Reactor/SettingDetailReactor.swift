//
//  SettingDetailReactor.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/12/02.
//

import Foundation
import ReactorKit

class SettingDetailReactor: Reactor {
    
    var initialState: State
    
    init(targetId: UUID, settingList: [SettingListItem]) {
        initialState = .init(settingList: [any SettingItemValue]())
    }
    
    struct State {
        @Pulse var settingList: [any SettingItemValue]
    }
    
    var settingList: [any SettingItemValue] {
        currentState.settingList
    }
    
    enum Action {
        case setItemValue((id: UUID, value: Any))
    }
    
    enum Mutation {
        case setItemValue((id: UUID, value: Any))
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        return initialState
    }
}
