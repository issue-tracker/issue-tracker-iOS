//
//  SettingReactor.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/28.
//

import ReactorKit

class SettingReactor: Reactor {
    var initialState: State = .init()
    
    private var model = SettingMainListModel()
    
    init() {
        initialState.settingList = model.getList(nil)
    }
    
    var settingList: [SettingListItem] {
        currentState.settingList
    }
    
    struct State {
        @Pulse var settingList = [SettingListItem]()
        var previousId: UUID? = nil
    }
    
    enum Action {
        case listSelected(UUID)
        case backButtonSelected
        case fetchItemValue(SettingItemValue)
    }
    
    enum Mutation {
        case updateSelectedListId(UUID?)
        case setItemValue(SettingItemValue)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .listSelected(let id):
            return Observable.just(Mutation.updateSelectedListId(id))
        case .backButtonSelected:
            return Observable.just(Mutation.updateSelectedListId(currentState.previousId))
        case .fetchItemValue(let value):
            return Observable.just(Mutation.setItemValue(value))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = currentState
        switch mutation {
        case .updateSelectedListId(let targetID):
            state.previousId = state.settingList.first?.parentId
            state.settingList = model.getList(targetID)
        case .setItemValue(let value):
            model.setItemValue(value)
            state.settingList = model.getList(state.previousId)
        }
        return state
    }
}