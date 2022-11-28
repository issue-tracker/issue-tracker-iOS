//
//  CellEntityAdaptable.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/15.
//

import Foundation

protocol CellEntityAdaptable {
    associatedtype Entity
    var index: Int { get set }
    func setEntity(_ entity: Entity, at index: Int) // SettingItem or SettingCategory
}
