//
//  MasterSettingsViewModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/06.
//

import Foundation
import UIKit

protocol SettingItem {
    func getName() -> String
    func getNextView() -> UIViewController
}

protocol SettingsViewModel {
    associatedtype E
    var sectionItems: [E] { get }
    func cellItems(section: Int) -> [SettingItem]
}

/// Setting 을 위한 카테고리와 값을 정의하는 모델
class MasterSettingsViewModel: SettingsViewModel {
    
    typealias E = String
    
    let settingsCategory = SettingsCategory.allCases
    let generalSettingItem = GeneralSettings.allCases
    let issueSettingItem = IssueSettings.allCases
    let labelSettingItem = LabelSettings.allCases
    let milestoneSettingItem = MilestoneSettings.allCases
    
    subscript(index: Int) -> [SettingItem] {
        switch index {
        case 0: return generalSettingItem
        case 1: return issueSettingItem
        case 2: return labelSettingItem
        case 3: return milestoneSettingItem
        default: return []
        }
    }
    
    var sectionItems: [E] {
        SettingsCategory.allCases.map({ $0.rawValue })
    }
    
    func cellItems(section: Int) -> [SettingItem] {
        switch section {
        case 0: return generalSettingItem
        case 1: return issueSettingItem
        case 2: return labelSettingItem
        case 3: return milestoneSettingItem
        default: return []
        }
    }
    
    func getSettingModel() -> [String: [SettingItem]] {
        var values = [self[0], self[1], self[2], self[3]]
        return settingsCategory.map({$0.rawValue}).reduce([String: [SettingItem]]()) { partialResult, key in
            return [key: values.removeFirst()]
        }
    }
    
    enum SettingsCategory: String, CaseIterable {
        case general
        case issue
        case label
        case milestone
    }
    
    enum GeneralSettings: String, CaseIterable, SettingItem {
        case login = "로그인 설정"
        case theme = "테마 설정"
        
        func getNextView() -> UIViewController {
            SettingIssueQueryViewController()
        }
        
        func getName() -> String {
            self.rawValue
        }
    }
    
    enum IssueSettings: String, CaseIterable, SettingItem {
        case list = "목록 설정"
        case detail = "상세 창 설정"
        case query = "기본 조회조건 설정"
        
        func getNextView() -> UIViewController {
            switch self {
            case .list:
                return SettingIssueListViewController()
            case .detail:
                return SettingIssueDetailViewController()
            case .query:
                return SettingIssueQueryViewController()
            }
        }
        
        func getName() -> String {
            self.rawValue
        }
    }
    
    enum LabelSettings: String, CaseIterable, SettingItem {
        case list = "목록 설정"
        case detail = "상세 창 설정"
        case query = "기본 조회조건 설정"
        
        func getNextView() -> UIViewController {
            SettingIssueQueryViewController()
        }
        
        func getName() -> String {
            self.rawValue
        }
    }
    
    enum MilestoneSettings: String, CaseIterable, SettingItem {
        case list = "목록 설정"
        case query = "기본 조회조건 설정"
        
        func getNextView() -> UIViewController {
            SettingIssueQueryViewController()
        }
        
        func getName() -> String {
            self.rawValue
        }
    }
}
