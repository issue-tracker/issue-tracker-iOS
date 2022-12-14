//
//  SettingReactor.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/28.
//

import Foundation
import ReactorKit

class SettingReactor: Reactor {
    var initialState: State = .init()
    
    private var model = SettingMainListModel()
    
    init() {
        initialState.settingList = model.getAllListItems()
    }
    
    var currentListCount: Int {
        allItems.count
    }
    
    var allItems: [SettingListItem] {
        currentState.settingList
    }
    
    struct State {
        @Pulse var settingList = [SettingListItem]()
        @Pulse var updatingId: UUID?
    }
    
    enum Action {
        case updateItemIntiate(IndexPath)
    }
    
    enum Mutation {
        case updateItemInMutating(SettingListItem)
        case updateItemMutated(any SettingItemValue)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        return currentState
    }
}
