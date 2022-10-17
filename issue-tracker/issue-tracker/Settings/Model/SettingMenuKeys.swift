//
//  SettingMenuKeys.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/14.
//

import UIKit

// MARK: - 저장하려는 타입

protocol PersistentKey {
    func getPersistentKey() -> String
}

// MARK: - 설정 창 추상타입

protocol SettingCategory {
    func getName() -> String
    func getNextView() -> UIViewController?
}

protocol SettingItem {
    var title: String { get set }
    var isActivated: Bool { get set }
}

// MARK: - 설정 창 구체타입

enum SettingSection: String, CaseIterable {
    case general
    case issue
    case label
    case milestone
}

enum GeneralSettings: String, CaseIterable, PersistentKey {
    case login = "로그인 설정"
    case theme = "테마 설정"
    
    func getPersistentKey() -> String {
        "GENERAL_"+self.rawValue
    }
}

enum IssueSettings: String, CaseIterable, PersistentKey {
    case list = "목록 설정"
    case detail = "상세 창 설정"
    case query = "기본 조회조건 설정"
    
    func getPersistentKey() -> String {
        "ISSUE_"+self.rawValue
    }
}

enum LabelSettings: String, CaseIterable, PersistentKey {
    case list = "목록 설정"
    case detail = "상세 창 설정"
    case query = "기본 조회조건 설정"
    
    func getPersistentKey() -> String {
        "LABEL_"+self.rawValue
    }
}

enum MilestoneSettings: String, CaseIterable, PersistentKey {
    case list = "목록 설정"
    case query = "기본 조회조건 설정"
    
    func getPersistentKey() -> String {
        "MILESTONE_"+self.rawValue
    }
}
