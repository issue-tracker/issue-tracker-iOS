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
        case setItemBoolean(Bool)
        case setColorSetting(RGBColor, Float)
        case setLoginActive(SocialType, Bool)
        case setRange(Int)
    }
    
    enum Mutation {
        case setItem(SettingListItem)
        case setItemValue(Any)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setItem(let item):
            return Observable.just(Mutation.setItem(item))
        case .setItemBoolean(let value):
            return Observable.just(Mutation.setItemValue(value))
        case .setColorSetting(let colorType, let value):
            guard let setting = currentState.value?.value as? SettingItemColor else {
                return .empty()
            }
            
            switch colorType {
            case .red: setting.rgbRed = value
            case .blue: setting.rgbBlue = value
            case .green: setting.rgbGreen = value
            }
            
            return Observable.just(Mutation.setItemValue(setting))
        case .setLoginActive(let socialType, let value):
            guard let setting = currentState.value?.value as? SettingItemLoginActivate else {
                return .empty()
            }
            
            switch socialType {
            case .github: setting.github = value
            case .naver: setting.naver = value
            case .kakao: setting.kakao = value
            }
            
            return Observable.just(Mutation.setItemValue(setting))
        case .setRange(let value):
            guard
                let rangeValue = currentState.value?.value as? SettingItemRange,
                rangeValue.minValue...rangeValue.maxValue ~= value
            else {
                return .empty()
            }
            
            rangeValue.currentValue = value
            return Observable.just(Mutation.setItemValue(rangeValue))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = currentState
        
        switch mutation {
        case .setItem(let item):
            state.value = item
        case .setItemValue(let value):
            state.value?.setValue(value, forKeyPath: #keyPath(SettingListItem.value))
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
