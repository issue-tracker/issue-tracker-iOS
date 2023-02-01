//
//  TransformableHelper.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/28.
//

import Foundation

class TransformableHelper {
    static func register() {
        ColorAttributeTransformer.register()
        CategorisedSettingListsTransformable.register()
        SettingValueTransformable.register()
    }
}
