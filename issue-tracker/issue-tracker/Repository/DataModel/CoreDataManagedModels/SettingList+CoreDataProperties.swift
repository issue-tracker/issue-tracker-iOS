//
//  SettingList+CoreDataProperties.swift
//  
//
//  Created by 백상휘 on 2022/12/14.
//
//

import Foundation
import CoreData


extension SettingList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SettingList> {
        return NSFetchRequest<SettingList>(entityName: "SettingList")
    }

    @NSManaged public var title: String
    @NSManaged public var parent: SettingCategory
    @NSManaged public var values: NSOrderedSet?

}
