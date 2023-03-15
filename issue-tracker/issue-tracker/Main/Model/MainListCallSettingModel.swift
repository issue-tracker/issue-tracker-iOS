//
//  MainListCallSettingModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2023/03/03.
//

import Foundation
import CoreData

class MainListCallSettingModel<ValueType> {
    
    var settingTitle: String = "" {
        willSet {
            settingValue = nil
            loadSettingItem(newValue)
        }
    }
    
    private(set) var settingValue: ValueType?
    
    private func loadSettingItem(_ key: String) {
        let fetch = SettingListItem.fetchRequest()
        fetch.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(SettingListItem.mainTitle), key])
        
        do {
            guard
                let result = try NSManagedObjectContext.viewContext?.fetch(fetch).first,
                let value = result.value as? ValueType
            else {
                return
            }
            
            self.settingValue = value
        } catch {
            print(error)
        }
    }
}
