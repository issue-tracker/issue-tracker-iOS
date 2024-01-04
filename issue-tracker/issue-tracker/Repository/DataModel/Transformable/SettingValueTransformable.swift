//
//  SettingValueTransformable.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/12/14.
//

import Foundation

class SettingValueTransformable: NSSecureUnarchiveFromDataTransformer {
  override class var allowedTopLevelClasses: [any AnyClass] {
    [
      CFBoolean.self,
      SettingItemColor.self,
      SettingItemRange.self,
      SettingItemLoginActivate.self
    ]
  }
  
  static func register() {
    let className = String(describing: SettingValueTransformable.self)
    let name = NSValueTransformerName(className)
    let transformer = SettingValueTransformable()
    
    ValueTransformer.setValueTransformer(transformer, forName: name)
  }
}
