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
        let category = model.getCategoryArray()
        initialState.settingCategory = category
        initialState.settingTableViewList = category.map({ category in
            SettingTableViewList(isCategory: true, title: category.title, type: .category)
        })
    }
    
    /// 현재 Reactor.View 에서 보여주고 있는 Item 이 어떤 타입인지 저장하고 있음.
    /// category일 경우 category만 보여줘야 함.
    /// list일 경우 category를 선택함으로써 보여줘야 하므로
    enum SettingListType {
        case category
        case list
        case item
    }
    
    struct State {
        @Pulse var settingTableViewList: [SettingTableViewList] = []
        
        var settingCategory = [SettingCategory]()
        var settingList = [SettingList]()
        var settingItem = [SettingListItem]()
        var updatingId: UUID?
        var settingListType: SettingListType = .category
        
        func currentItem(at indexPath: IndexPath) -> Any? {
            switch settingListType {
            case .category:
                return settingCategory[indexPath.row]
            case .list:
                return settingList[indexPath.row]
            case .item:
                return settingItem[indexPath.row]
            }
        }
        
        func getListCount() -> Int {
            switch settingListType {
            case .category:
                return settingCategory.count
            case .list:
                return settingList.count
            case .item:
                return settingItem.count
            }
        }
    }
    
    struct SettingTableViewList {
        let isCategory: Bool
        let title: String?
        let type: SettingListType
    }
    
    enum Action {
        case selectCategory(_ category: SettingCategory)
        case backToCategory
        
        case selectList(_ list: SettingList)
        case backToList
        
        case sendListType(_ type: SettingListType)
    }
    
    enum Mutation {
        case updateCategory(_ items: [SettingCategory])
        case updateList(_ items: [SettingList])
        case updateItem(_ items: [SettingListItem])
        case updateCurrentListType(_ type: SettingListType)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        return Observable.just({
            switch action {
            case .selectCategory(let category):
                return Mutation
                    .updateList(model.getListArray(parent: category))
            case .backToCategory:
                return Mutation
                    .updateCategory(currentState.settingCategory)
            case .selectList(let list):
                return Mutation
                    .updateItem(model.getItemArray(parent: list))
            case .backToList:
                return Mutation
                    .updateList(currentState.settingList)
            case .sendListType(let type):
                return Mutation
                    .updateCurrentListType(type)
            }
        }())
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .updateCategory(let items):
            state.settingCategory = items
            state.settingTableViewList = items.map({ category in
                SettingTableViewList(isCategory: true, title: category.title, type: .category)
            })
        case .updateList(let items):
            state.settingList = items
            state.settingTableViewList = items.map({ list in
                SettingTableViewList(isCategory: false, title: list.title, type: .list)
            })
        case .updateItem(let items):
            state.settingItem = items
            state.settingTableViewList = items.map({ item in
                SettingTableViewList(isCategory: false, title: item.mainTitle, type: .item)
            })
        case .updateCurrentListType(let type):
            state.settingListType = type
        }
        
        return state
    }
    
    func getListTitle(_ item: Any?) -> String? {
        var result: String?
        
        switch item {
        case let category as SettingCategory:
            result = category.title
        case let list as SettingList:
            result = list.title
        case let item as SettingListItem:
            result = item.mainTitle
        default:
            return nil
        }
        
        func checkResult(_ result: inout String) {
            guard result.count > 8 else { return }
            
            result.removeSubrange(result.index(result.startIndex, offsetBy: 8)...)
            result.append(contentsOf: "..")
        }
        
        if var result {
            checkResult(&result)
            return result
        } else {
            return nil
        }
    }
}
