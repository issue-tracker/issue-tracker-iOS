//
//  SettingMenuKeys.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/14.
//

import UIKit

// General: ["로그인 설정", "테마 설정"], Issue: ["목록 설정", "상세 창 설정", "기본 조회조건 설정"], Label: ["목록 설정", "상세 창 설정", "기본 조회조건 설정"], Milestone: ["목록 설정", "기본 조회조건 설정"]

// 리스트를 가져오는 리액터 + 데이터 모델을 가져오는 모델 만들어서 조합. 데이터 모델은 각 설정 항목(Item) 별로 하나씩.

// MARK: - 저장하려는 타입

protocol PersistentKey {
    func getPersistentKey() -> String
}

// MARK: - 설정 창 추상타입

/// 설정 창 Category Entity 를 위한 프로토콜. 화면에 표시되어야 할 이름과 다음 ViewController를 반환한다.
protocol SettingCategory {
    func getName() -> String
    func getNextView() -> UIViewController?
}

/// 설정 창 Item Entity 를 위한 프로토콜.
protocol SettingItemClickable {
    var title: String { get set }
    var isActivated: Bool { get set }
}

protocol SettingItemEntityContained {
    var title: String { get set }
    var entity: Any { get set }
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
