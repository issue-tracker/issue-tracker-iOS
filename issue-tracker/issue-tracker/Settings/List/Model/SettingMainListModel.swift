//
//  SettingMainListModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/29.
//

import Foundation
import CoreData

class SettingMainListModel {
    
    init() {
        initializeList()
    }
    
    private func initializeList() {
        
    }
    
    func getList(_ id: UUID?, list: [SettingListItem]? = nil) -> [SettingListItem] {
        return [SettingListItem]()
    }
    
    /// CoreData에서 SettingItemValue들을 Query하는 API로 변경 필요.
    func getAllItemValues(_ item: SettingListItem) -> [String: any SettingItemValue] {
        return [:]
    }
    
    /// CoreData에서 SettingItemValue들을 Query하는 API로 변경 필요.
    func getAllItemValues(_ id: UUID) -> [String: any SettingItemValue] {
        return [:]
    }
    
    /// CoreData에서 SettingItemValue을 Commit하는 API로 변경 필요.
    func setItemValue(_ value: any SettingItemValue) {
    }
    
    /// CoreData에서 SettingItemValue을 Commit하는 API로 변경 필요.
    ///
    /// index, IndexPath, UUID 등 여러 방식을 통해 리스트와 아이템을 가져오는 API를 간략하게 제공할 필요가 있다.
    func getAllListItems() -> [SettingListItem] {
        guard let context = NSManagedObjectContext.viewContext else {
            return []
        }
        
        let fetch = SettingListItem.fetchRequest()
        var result = [SettingListItem]()
        
        do {
            result = try context.fetch(fetch)
        } catch {
            print(error)
        }
        
        return result
    }
    
    /// CoreData에서 SettingItemValue을 Commit하는 API로 변경 필요.
    ///
    /// index, IndexPath, UUID 등 여러 방식을 통해 리스트와 아이템을 가져오는 API를 간략하게 제공할 필요가 있다.
    func getListItem(_ index: Int) -> SettingListItem {
        return SettingListItem()
    }
}

enum SettingListType: Int, CaseIterable {
    case title = 0
    case item = 1
}

//struct SettingListItem {
//    let id: UUID
//    let parentId: UUID?
//    let title: String
//    private let listValue: Int
//    let listType: SettingListType
//
//    init(id: UUID, title: String, parentId: UUID? = nil, listTypeValue: Int = 1) {
//        self.id = id
//        self.title = title
//        self.parentId = parentId
//        self.listValue = listTypeValue
//        self.listType = SettingListType.allCases.first(where: {$0.rawValue == listTypeValue}) ?? SettingListType.item
//    }
//
//    var subList = [SettingListItem]()
//    var values: [String: any SettingItemValue] = .init()
//}

struct SettingListItemActivated: SettingItemValue {
    typealias SettingValue = Bool
    
    let id: UUID = .init()
    let mainTitle: String
    let subTitle: String?
    let parentId: UUID?
    
    let order: Int
    
    var value: Bool
}

struct SettingListItemValueColor: SettingItemValue {
    typealias SettingValue = SettingListItemColor
    
    let id: UUID = .init()
    let mainTitle: String
    let subTitle: String?
    let parentId: UUID?
    
    let order: Int
    
    var value: SettingListItemColor
}

class SettingListItemColor {
  var rgbRed: Float
  var rgbGreen: Float
  var rgbBlue: Float
  
  init(rgbRed: Float, rgbGreen: Float, rgbBlue: Float) {
    self.rgbRed = rgbRed
    self.rgbGreen = rgbGreen
    self.rgbBlue = rgbBlue
  }
}

struct SettingListItemValueList: SettingItemValue {
    typealias SettingValue = Array<any SettingItemValue>

    let id: UUID = .init()
    let mainTitle: String
    let subTitle: String?
    let parentId: UUID?

    let order: Int

    var value: SettingValue
}

struct SettingListItemValueImage: SettingItemValue {
    typealias SettingValue = Optional<Data>
    
    let id: UUID = .init()
    let mainTitle: String
    let subTitle: String?
    let parentId: UUID?
    
    let order: Int
    
    var value: Optional<Data>
}

struct SettingListItemValueString: SettingItemValue {
    typealias SettingValue = String
    
    let id: UUID = .init()
    let mainTitle: String
    let subTitle: String?
    let parentId: UUID?
    
    let order: Int
    
    var value: String
}

protocol SettingItemValue {
    associatedtype SettingValue
    
    var id: UUID { get }
    
    /// 같으면 한 그룹으로 인식
    var mainTitle: String { get }
    var subTitle: String? { get }
    var parentId: UUID? { get }
    
    var order: Int { get }
    
    var value: SettingValue { get set }
}

//extension SettingListItem: Equatable {
//    static func == (lhs: SettingListItem, rhs: SettingListItem) -> Bool {
//        lhs.id == rhs.id
//    }
//}
