//
//  SettingMenuModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/28.
//

import Foundation
import CoreData

class SettingMenuModel: CoreDataContext {
    
    var items: [NSManagedObject] = []
    
    init() {
        guard let managedContext else {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SettingItem")
        
        do {
            self.items = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
        }
    }
}
