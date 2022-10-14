//
//  MasterSettingsViewModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/06.
//

import Foundation
import UIKit

protocol SettingViewModel {
    var sectionItems: [SettingSection] { get }
    func cellItems(section: Int) -> [SettingCategory]
}

/// Setting 을 위한 카테고리와 값을 정의하는 모델
class MasterSettingsViewModel: SettingViewModel {
    var sectionItems: [SettingSection] {
        SettingSection.allCases
    }
    
    func cellItems(section: Int) -> [SettingCategory] {
        switch section {
        case 0: return GeneralSettings.allCases
        case 1: return IssueSettings.allCases
        case 2: return LabelSettings.allCases
        case 3: return MilestoneSettings.allCases
        default: return []
        }
    }
    
    func getSettingModel() -> [String: [SettingCategory]] {
        var values = [cellItems(section: 0), cellItems(section: 1), cellItems(section: 2), cellItems(section: 3)]
        return SettingSection.allCases.map({$0.rawValue}).reduce([String: [SettingCategory]]()) { partialResult, key in
            return [key: values.removeFirst()]
        }
    }
}
