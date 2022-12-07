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
        switch action {
        case .updateItemIntiate(let indexPath):
            let updateItem = currentState.settingList[indexPath.row]
            guard updateItem.listType == .item else {
                return .empty()
            }
            
            let mutation = Mutation.updateItemInMutating(updateItem)
            return Observable.just(mutation)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = currentState
        switch mutation {
        case .updateItemInMutating(let item):
            state.updatingId = item.id
        case .updateItemMutated(let value):
            model.setItemValue(value)
        }
        return state
    }
}
