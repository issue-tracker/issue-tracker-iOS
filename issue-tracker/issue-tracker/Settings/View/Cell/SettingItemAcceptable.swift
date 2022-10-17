//
//  SettingItemAcceptable.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/15.
//

import Foundation

protocol SettingItemAcceptable {
    var index: Int { get set }
    func setEntity(_ entity: SettingItem, at index: Int)
}
