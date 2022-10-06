//
//  SettingsViewModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/06.
//

import Foundation

/// Setting 을 위한 카테고리와 값을 정의하는 모델
class SettingsViewModel {
    let settingsCategory = ["GENERAL" ,"ISSUE", "LABEL", "MILESTONE"]
    let generalSettingItem = ["로그인 설정", "테마 설정"]
    let issueSettingItem = ["목록 설정", "상세 창 설정", "기본 조회조건 설정"]
    let labelSettingItem = ["목록 설정", "상세 창 설정", "기본 조회조건 설정"]
    let milestoneSettingItem = ["목록 설정", "기본 조회조건 설정"]
    
    subscript(index: Int) -> [String] {
        switch index {
        case 0: return generalSettingItem
        case 1: return issueSettingItem
        case 2: return labelSettingItem
        case 3: return milestoneSettingItem
        default: return []
        }
    }
    
    func getSettingModel() -> [String: [String]] {
        var values = [generalSettingItem, issueSettingItem, labelSettingItem, milestoneSettingItem]
        return settingsCategory.reduce([String: [String]]()) { partialResult, key in
            return [key: values.removeFirst()]
        }
    }
}
