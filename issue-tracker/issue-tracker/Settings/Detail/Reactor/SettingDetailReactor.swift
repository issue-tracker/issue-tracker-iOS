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
            value: item
        )
        
    }
    
    struct State {
        var mainTitle: String?
        var subTitle: String?
        
        @Pulse var value: SettingListItem?
    }
    
    enum Action {
        case setItem(SettingListItem)
        case setItemValue(Any)
    }
    
    enum Mutation {
        case setItem(SettingListItem)
        case setItemValue(Any)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setItem(let item):
            return Observable.just(Mutation.setItem(item))
        case .setItemValue(let value):
            return Observable.just(Mutation.setItemValue(value))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = currentState
        
        switch mutation {
        case .setItem(let item):
            state.value = item
        case .setItemValue(let value):
            var mutatedValue: Any? {
                if type(of: value) == type(of: currentState.value) {
                    return value
                } else if let value = cfCast(value, to: CFBoolean.self) {
                    return value
                }
                
                return nil
            }
            
            if let mutatedValue {
                state.value?.value = mutatedValue
            }
        }
        
        do {
            try NSManagedObjectContext.viewContext?.save()
        } catch {
            print(error)
        }
        
        return state
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
