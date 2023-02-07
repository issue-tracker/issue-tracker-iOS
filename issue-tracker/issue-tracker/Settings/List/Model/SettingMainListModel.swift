//
//  SettingMainListModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/29.
//

import Foundation
import CoreData

class SettingMainListModel {
    
    func getCategoryArray() -> [SettingCategory] {
        guard let context = NSManagedObjectContext.viewContext else {
            return []
        }
        
        var result = [SettingCategory]()
        
        do {
            result = try context.fetch(SettingCategory.fetchRequest())
        } catch {
            print(error)
        }
        
        return result
    }
    
    func getListArray(parent category: SettingCategory) -> [SettingList] {
        guard let context = NSManagedObjectContext.viewContext else {
            return []
        }

        let fetch = SettingList.fetchRequest()
        fetch.predicate = NSPredicate(
            format: "%K = %@",
            argumentArray: [#keyPath(SettingList.parent), category]
        )

        var result = [SettingList]()

        do {
            result = try context.fetch(fetch)
        } catch {
            print(error)
        }
        
        return result
//        let result = getDataFromCoreData(
//            argumentObject: category,
//            objectKeyPath: #keyPath(SettingList.parent)) as? [SettingList]
//
//        return result ?? []
    }
    
    func getItemArray(parent list: SettingList) -> [SettingListItem] {
        guard let context = NSManagedObjectContext.viewContext else {
            return []
        }

        let fetch = SettingListItem.fetchRequest()
        fetch.predicate = NSPredicate(
            format: "%K = %@",
            argumentArray: [#keyPath(SettingListItem.parent), list]
        )

        var result = [SettingListItem]()

        do {
            result = try context.fetch(fetch)
        } catch {
            print(error)
        }
        
        return result
//        let result = getDataFromCoreData(
//            argumentObject: list,
//            objectKeyPath: #keyPath(SettingListItem.parent)) as? [SettingListItem]
//
//        return result ?? []
    }
    
    private func getDataFromCoreData<CDObjectType: NSManagedObject, CDReturnType: NSManagedObject>(argumentObject: CDObjectType, objectKeyPath: String) -> [CDReturnType] {
        guard let context = NSManagedObjectContext.viewContext else {
            return []
        }
        
        let fetch = CDReturnType.fetchRequest()
        fetch.predicate = NSPredicate(
            format: "%K = %@",
            argumentArray: [objectKeyPath, argumentObject]
        )
        
        var result = [CDReturnType]()
        
        do {
            let fetchResult = try context.fetch(fetch)
            
            if let fetchResult = fetchResult as? [CDReturnType] {
                result = fetchResult
            }
        } catch {
            print(error)
        }
        
        return result
    }
}

enum SettingListType: Int, CaseIterable {
    case title = 0
    case item = 1
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
