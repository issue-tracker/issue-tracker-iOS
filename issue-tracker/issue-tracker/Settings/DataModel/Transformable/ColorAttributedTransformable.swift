//
//  UIViewController+Transformable.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/28.
//

import UIKit

class ColorAttributeTransformer: NSSecureUnarchiveFromDataTransformer {
    override class var allowedTopLevelClasses: [AnyClass] {
        [UIColor.self]
    }
    
    static func register() {
        let className = String(describing: ColorAttributeTransformer.self)
        let name = NSValueTransformerName(className)
        let transformer = ColorAttributeTransformer()
        
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
