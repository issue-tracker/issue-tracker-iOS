//
//  SettingDetailReactor.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/12/02.
//

import Foundation
import ReactorKit
import CoreData

class SettingDetailReactor: Reactor {
    var model: SettingListItemUpdateModel?
    var initialState: State
    
    init(item: SettingListItem?) {
        self.model = .init(item)
        
        initialState = State(
            mainTitle: item?.mainTitle,
            subTitle: item?.subTitle,
            value: item?.value
        )
        
    }
    
    struct State {
        var mainTitle: String?
        var subTitle: String?
        
        @Pulse var value: Any?
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

class SettingListItemUpdateModel {
    
    private var item: SettingListItem
    
    init?(_ item: SettingListItem?) {
        if let item {
            self.item = item
        } else {
            return nil
        }
    }
}
