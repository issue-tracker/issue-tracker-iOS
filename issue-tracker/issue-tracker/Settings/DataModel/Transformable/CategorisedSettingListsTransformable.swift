//
//  CategorisedSettingListsTransformable.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/28.
//

import Foundation

class CategorisedSettingListsTransformable: NSSecureUnarchiveFromDataTransformer {
    override class var allowedTopLevelClasses: [AnyClass] {
        [NSArray.self, NSMutableArray.self]
    }
    
    static func register() {
        let className = String(describing: CategorisedSettingListsTransformable.self)
        let name = NSValueTransformerName(className)
        let transformer = CategorisedSettingListsTransformable()
        
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
