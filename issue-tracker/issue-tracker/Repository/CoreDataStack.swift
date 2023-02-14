//
//  CoreDataStack.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/12/13.
//

import CoreData

final class CoreDataStack {
    typealias Entity = NSManagedObject
    
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
        
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        persistentContainer.persistentStoreDescriptions = [persistentStoreDescription]
        persistentContainer.loadPersistentStores(completionHandler: { _, error in
            if let error = error as? NSError {
                fatalError()
            }
        })
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
        do {
            
            for item in (try context.fetch(SettingCategory.fetchRequest())) {
                print("SettingCategory Delete")
                context.delete(item)
            }
            
            for item in (try context.fetch(SettingList.fetchRequest())) {
                print("SettingList Delete")
                context.delete(item)
            }
            
            for item in (try context.fetch(SettingListItem.fetchRequest())) {
                print("SettingListItem Delete")
                context.delete(item)
            }
            
            try saveContext()
            
            completionHandler?()
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
                        obj3.order = Int16(item.order)
                        
                        if let value = item.value as? Bool {
                            obj3.value = value ? kCFBooleanTrue : kCFBooleanFalse
                        } else {
                            obj3.value = item.value
                        }
                        
                        obj3.parent = obj2
                        
                        listItems.append(obj3)
                    }
                    
                    categoryItems.append(obj2)
                    obj2.values = NSOrderedSet(array: listItems)
                }
                
                obj.items = NSOrderedSet(array: categoryItems)
            }
            
            try saveContext()
            completionHandler?()
        } catch let error as NSError {
            print(error)
        }
    }
}
