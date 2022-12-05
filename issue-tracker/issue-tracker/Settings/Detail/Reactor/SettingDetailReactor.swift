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
    var items: [any SettingItemValue] = []
    
    init(targetId: UUID, generalInfo: SettingListItem, allListInfo: SettingListItem) {
        
        for item in (generalInfo.subList + allListInfo.subList) {
            if item.id == targetId {
                self.items = item.values.map({$0.value})
            }
        }
        
        initialState = .init(settingList: items)
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
