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
    
    init(targetId: UUID, settingList: [SettingListItem]) {
        
        var values = [any SettingItemValue]()
        for item in settingList {
            if item.id == targetId {
                values.append(contentsOf: item.values.map({$0.value}))
            }
        }
        
        initialState = .init(settingList: values)
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
