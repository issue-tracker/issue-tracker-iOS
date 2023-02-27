//
//  CoreDataStack.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/12/13.
//

import CoreData

final class CoreDataStack {
    typealias Entity = NSManagedObject
    enum ValueType: String, CaseIterable {
        case rgb_color, range, boolean
        case login_activate
        
        static func getType(query str: String) -> ValueType? {
            return Self.allCases.first { type in
                type.rawValue.contains(str)
            }
        }
    }
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SettingDataModel")
        
        container.loadPersistentStores(completionHandler: {
            
            (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    init() {
        TransformableHelper.register()
        resetDefaultSetting()
    }
    
    // MARK: - Core Data Saving support
    
    /// Warning!! It will remove all setting lists.
    func resetDefaultSetting() {
        removeAllSettingLists()
        insertAllSettingLists()
    }
    
    func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }
    
    func saveContextWithNoError() {
        if context.hasChanges {
            try? context.save()
        }
    }
    
    private func removeAllSettingLists(_ completionHandler: (()->Void)? = nil) {
        let fetch = SettingListItem.fetchRequest()
        
        do {
            let result = try context.fetch(fetch)
            for item in result {
                context.delete(item)
            }
            
            try context.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    private func insertAllSettingLists(_ completionHandler: (()->Void)? = nil) {
        
        guard
            let url = Bundle.main.url(forResource: "settingLists", withExtension: "json"),
            let jsonData = try? Data(contentsOf: url),
            let settingJSON = try? JSONDecoder().decode(SettingDecodable.self, from: jsonData)
        else {
            return
        }
        
        do {
            for category in settingJSON.contents {
                guard let obj = NSEntityDescription.insertNewObject(forEntityName: String(describing: SettingCategory.self), into: context) as? SettingCategory else {
                    continue
                }
                
                obj.title = category.title.localized
                obj.listTypeValue = Int16(category.listTypeValue)
                
                var categoryItems = [SettingList]()
                for list in category.items {
                    guard let obj2 = NSEntityDescription.insertNewObject(forEntityName: String(describing: SettingList.self), into: context) as? SettingList else {
                        continue
                    }
                    
                    obj2.title = list.title.localized
                    obj2.parent = obj
                    
                    var listItems = [SettingListItem]()
                    for item in list.values {
                        guard let obj3 = NSEntityDescription.insertNewObject(forEntityName: String(describing: SettingListItem.self), into: context) as? SettingListItem else {
                            continue
                        }
                        
                        obj3.mainTitle = item.mainTitle.localized
                        obj3.subTitle = item.subTitle.localized
                        obj3.desc = item.desc.localized
                        obj3.order = Int16(item.order)
                        obj3.parent = obj2
                        obj3.typeName = item.typeName
                        
                        switch ValueType.getType(query: item.typeName) {
                        case .boolean:
                            obj3.setValue(item.value as? Bool, forKeyPath: #keyPath(SettingListItem.value))
                        case .range:
                            obj3.setValue(item.value as? SettingItemRange, forKeyPath: #keyPath(SettingListItem.value))
                        case .login_activate:
                            obj3.setValue(item.value as? SettingItemLoginActivate, forKeyPath: #keyPath(SettingListItem.value))
                        case .rgb_color:
                            obj3.setValue(item.value as? SettingItemColor, forKeyPath: #keyPath(SettingListItem.value))
                        default:
                            obj3.setValue(item.value, forKeyPath: #keyPath(SettingListItem.value))
                        }
                        
                        listItems.append(obj3)
                    }
                    
                    categoryItems.append(obj2)
                    obj2.values = NSOrderedSet(array: listItems)
                }
                
                obj.items = NSOrderedSet(array: categoryItems)
            }
            
            try context.save()
            completionHandler?()
        } catch let error as NSError {
            print(error)
        }
    }
}
