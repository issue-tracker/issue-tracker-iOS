//
//  SettingListItem+CoreDataProperties.swift
//  
//
//  Created by 백상휘 on 2023/02/16.
//
//

import Foundation
import CoreData


extension SettingListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SettingListItem> {
        return NSFetchRequest<SettingListItem>(entityName: "SettingListItem")
    }

    @NSManaged public var mainTitle: String?
    @NSManaged public var order: Int16
    @NSManaged public var subTitle: String?
    @NSManaged public var value: Any?
    @NSManaged public var desc: String?
    @NSManaged public var parent: SettingList?

}
