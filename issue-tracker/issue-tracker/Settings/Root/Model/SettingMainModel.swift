//
//  SettingMainModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/06.
//

import Foundation

/// Setting에서 사용할 UITableView 의 모델 프로토콜로 정의
protocol SettingViewModel {
    var allSections: [SettingSection] { get }
    func sectionItems(section: Int) -> [SettingCategory]
}

/// Setting 창 중 메인 화면의 모델
class SettingMainModel: SettingViewModel {
    var allSections: [SettingSection] {
        SettingSection.allCases
    }
    
    func sectionItems(section: Int) -> [SettingCategory] {
        switch section {
//        case 0: return GeneralSettings.allCases
        case 1: return IssueSettings.allCases
        case 2: return LabelSettings.allCases
        case 3: return MilestoneSettings.allCases
        default: return []
        }
    }
    
    func getItem(from indexPath: IndexPath) -> SettingCategory? {
        let sectionItems = sectionItems(section: indexPath.section)
        guard 0..<sectionItems.count ~= indexPath.row else {
            return nil
        }
        
        return sectionItems[indexPath.row]
    }
}
