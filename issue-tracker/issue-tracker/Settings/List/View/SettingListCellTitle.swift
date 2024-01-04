//
//  SettingListCellTitle.swift
//  issue-tracker
//
//  Created by 백상휘 on 2023/02/24.
//

import Foundation

protocol SettingListCellTitle {
    var mainTitle: String? { get }
}

extension SettingList: SettingListCellTitle {
    var mainTitle: String? {
        self.title
    }
}

extension SettingCategory: SettingListCellTitle {
    var mainTitle: String? {
        self.title
    }
}
