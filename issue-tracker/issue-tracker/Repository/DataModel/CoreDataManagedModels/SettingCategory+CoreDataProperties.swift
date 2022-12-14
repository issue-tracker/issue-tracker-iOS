//
//  SettingCategory+CoreDataProperties.swift
//  
//
//  Created by 백상휘 on 2022/12/14.
//
//

import Foundation
import CoreData


extension SettingCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SettingCategory> {
        return NSFetchRequest<SettingCategory>(entityName: "SettingCategory")
    }

    @NSManaged public var title: String?
    @NSManaged public var listTypeValue: Int16
    @NSManaged public var items: NSOrderedSet?

}
