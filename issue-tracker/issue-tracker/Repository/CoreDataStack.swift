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
  
  // MARK: - Core Data Saving support
  
  func saveContext() throws {
    if context.hasChanges {
      try context.save()
    }
  }
  
  /// Check setting lists are saved.
  func checkSettingListAvailable() -> Bool {
    
    do {
      let categoryCount = try context
        .count(for: SettingCategory.fetchRequest())
      
      let listCount = try context
        .count(for: SettingList.fetchRequest())
      
      let itemCount = try context
        .count(for: SettingListItem.fetchRequest())
      
      return categoryCount > 0 && listCount > 0 && itemCount > 0
      
    } catch let error as NSError {
      print("Error occured \(error), \(error.userInfo)")
    }
    
    return false
  }
  
  /// Warning!! It will remove all setting lists.
  func resetDefaultSetting() {
    removeAllSettingLists {
      self.insertAllSettingLists()
    }
  }
  
  func removeAllSettingLists(_ completionHandler: (()->Void)? = nil) {
    
    do {
      var objects = [NSManagedObject]()
      
      objects = try context
        .fetch(SettingCategory.fetchRequest())
      objects.forEach {
        context.delete($0)
      }
      
      objects = try context
        .fetch(SettingList.fetchRequest())
      objects.forEach {
        context.delete($0)
      }
      
      objects = try context
        .fetch(SettingListItem.fetchRequest())
      objects.forEach {
        context.delete($0)
      }
      
      completionHandler?()
    } catch let error as NSError {
      print("Error occured \(error), \(error.userInfo)")
    }
  }
  
  private func insertAllSettingLists(_ completionHandler: (()->Void)? = nil) {
    guard
      let url = Bundle.main.url(forResource: "settingLists",
                                withExtension: "json"),
      let jsonData = try? Data(contentsOf: url),
      let jsonDict = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any]
    else {
      return
    }
    
    let contents = (jsonDict["contents"] as? [[String: Any]]) ?? [[:]]
    
    // TODO: Force unwrapping ALERT
    let categoryDesc = NSEntityDescription.entity(
      forEntityName: String(describing: SettingCategory.self),
      in: context)!
    
    let listDesc = NSEntityDescription.entity(
      forEntityName: String(describing: SettingList.self),
      in: context)!
    
    let listItemDesc = NSEntityDescription.entity(
      forEntityName: String(describing: SettingListItem.self),
      in: context)!
    
    var categories = [SettingCategory]()
    var listArray = [SettingList]()
    var listItemArray = [SettingListItem]()
    
    for categoryValue in contents {
      
      let settingCategory = SettingCategory(entity: categoryDesc,
                      insertInto: context)
      settingCategory.title = (categoryValue["title"] as? String)?.localized
      settingCategory.listTypeValue = (categoryValue["listTypeValue"] as? Int16) ?? 0
      
      if let items = categoryValue["items"] as? [[String: Any]] {
        
//        settingCategory.items = NSOrderedSet(array: items)
        
        for item in items {
          
          let settingList = SettingList(entity: listDesc,
                                        insertInto: context)
          
          settingList.title = (item["title"] as? String)?.localized ?? ""
          
          if let values = item["values"] as? [[String: Any]] {
//            settingList.values = NSOrderedSet(array: values)
            
            for value in values {
              
              let settingListItem = SettingListItem(entity: listItemDesc,
                                                    insertInto: context)
              
              settingListItem.mainTitle = (value["mainTitle"] as? String)?.localized ?? ""
              settingListItem.subTitle = (value["subTitle"] as? String)?.localized
              settingListItem.order = (value["order"] as? Int16) ?? 0
              settingListItem.value = value["value"]
              settingListItem.parent = settingList
              
              listItemArray.append(settingListItem)
            }
          }
          
          settingList.parent = settingCategory
          
          listArray.append(settingList)
        }
      }
      
      categories.append(settingCategory)
    }
    
    try? saveContext()
    
    completionHandler?()
  }
}
