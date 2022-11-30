//
//  SettingMainListModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/29.
//

import Foundation

class SettingMainListModel {
    private var generalInfo: SettingListItem
    private var allListInfo: SettingListItem
    
    init() {
        let generalId = UUID()
        generalInfo = SettingListItem(id: generalId, title: "일반 설정")
        
        let allListId = UUID()
        allListInfo = SettingListItem(id: allListId, title: "이슈/라벨/마일스톤 설정")
        
        initializeList()
    }
    
    private func initializeList() {
        
        /**
         일반 설정
           로그인 설정 = 자동 로그인 설정, 깃허브 간편 로그인, 네이버 간편 로그인, 카카오 간편 로그인
           테마 설정 = 다크 모드 적용 여부(3), 배경화면 색상 설정
         이슈/라벨/마일스톤 설정
           목록 설정 = 이슈 목록 배경 색, 라벨 목록 배경 색, 마일스톤 목록 배경 색
           이슈 상세 창 설정 = 라벨 표시, 프로필 이미지 표시
         */
        
        var loginSetting = SettingListItem(id: UUID(), title: "로그인 설정", parentId: generalInfo.id)
        loginSetting.values = [
            "enable-auto-login": SettingListItemActivated(mainTitle: "자동 로그인 설정", subTitle: "로그인 한 정보를 토대로 자동 로그인을 시도합니다.", parentId: loginSetting.id, order: 0, isActivated: false),
            "show-github-login": SettingListItemActivated(mainTitle: "깃허브 간편 로그인", subTitle: "간편 로그인-깃허브 를 활성화 합니다.", parentId: loginSetting.id, order: 1, isActivated: true),
            "show-naver-login": SettingListItemActivated(mainTitle: "네이버 간편 로그인", subTitle: "간편 로그인-네이버 를 활성화 합니다.", parentId: loginSetting.id, order: 2, isActivated: true),
            "show-kakao-login": SettingListItemActivated(mainTitle: "카카오 간편 로그인", subTitle: "간편 로그인-카카오 를 활성화 합니다.", parentId: loginSetting.id, order: 3, isActivated: true),
        ]
        
        var mainThemeSetting = SettingListItem(id: UUID(), title: "테마 설정", parentId: generalInfo.id)
        mainThemeSetting.values = [
            "light-theme-mode-enable": SettingListItemActivated(mainTitle: "다크 모드 적용 여부", subTitle: "라이트 모드", parentId: mainThemeSetting.id, order: 0, isActivated: false),
            "dark-theme-mode-enable": SettingListItemActivated(mainTitle: "다크 모드 적용 여부", subTitle: "다크 모드", parentId: mainThemeSetting.id, order: 0, isActivated: false),
            "system-theme-mode-enable": SettingListItemActivated(mainTitle: "다크 모드 적용 여부", subTitle: "시스템", parentId: mainThemeSetting.id, order: 0, isActivated: true),
            "color-background": SettingListItemValueColor(mainTitle: "배경화면 색상 설정", subTitle: nil, parentId: mainThemeSetting.id, order: 0, rgbRed: 0, rgbGreen: 0, rgbBlue: 0),
        ]
        
        generalInfo.subList = [
            loginSetting,
            mainThemeSetting
        ]
        
        var listSetting = SettingListItem(id: UUID(), title: "목록 설정", parentId: allListInfo.id)
        listSetting.values = [
            "issue-list-background-color": SettingListItemValueColor(mainTitle: "이슈 목록 배경 색", subTitle: "목록에 표시될 셀들의 배경색을 설정합니다.", parentId: listSetting.id, order: 0, rgbRed: 58, rgbGreen: 128, rgbBlue: 255),
            "label-list-background-color": SettingListItemValueColor(mainTitle: "라벨 목록 배경 색", subTitle: "목록에 표시될 셀들의 배경색을 설정합니다.", parentId: listSetting.id, order: 0, rgbRed: 58, rgbGreen: 128, rgbBlue: 255),
            "milestone-list-background-color": SettingListItemValueColor(mainTitle: "마일스톤 목록 배경 색", subTitle: "목록에 표시될 셀들의 배경색을 설정합니다.", parentId: listSetting.id, order: 0, rgbRed: 58, rgbGreen: 128, rgbBlue: 255),
        ]
        
        var issueDetailSetting = SettingListItem(id: UUID(), title: "이슈 상세 창 설정", parentId: allListInfo.id)
        issueDetailSetting.values = [
            "will-show-labels": SettingListItemActivated(mainTitle: "라벨 표시", subTitle: nil, parentId: issueDetailSetting.id, order: 0, isActivated: true),
            "will-show-profileImage": SettingListItemActivated(mainTitle: "프로필 이미지 표시", subTitle: nil, parentId: issueDetailSetting.id, order: 1, isActivated: true),
            "shorten-comments-in-detail-screen": SettingListItemActivated(mainTitle: "", subTitle: nil, parentId: issueDetailSetting.id, order: 2, isActivated: false)
        ]
        
        let stubSetting = SettingListItem(id: UUID(), title: "테스트용", parentId: allListInfo.id)
        
        allListInfo.subList = [
            listSetting,
            issueDetailSetting,
            stubSetting
        ]
    }
    
    func getList(_ id: UUID?, list: [SettingListItem]? = nil) -> [SettingListItem] {
        guard let id else {
            return [generalInfo, allListInfo]
        }
        
        var result = [SettingListItem]()
        let list = list ?? [generalInfo, allListInfo]
        
        for item in list {
            if item.id == id {
                return item.subList
            } else {
                result += getList(item.id, list: item.subList)
            }
        }
        
        return result
    }
    
    #if DEBUG
    var getMainItems: [SettingListItem] {
        return [generalInfo, allListInfo]
    }
    #endif
}

struct SettingListItem {
    let id: UUID
    let parentId: UUID?
    let title: String
    
    init(id: UUID, title: String, parentId: UUID? = nil) {
        self.id = id
        self.title = title
        self.parentId = parentId
    }
    
    var subList = [SettingListItem]()
    var values: [String: SettingItemValue] = .init()
}

struct SettingListItemActivated: SettingItemValue {
    let mainTitle: String
    let subTitle: String?
    let parentId: UUID?
    
    let order: Int
    
    var isActivated: Bool
}

struct SettingListItemValueColor: SettingItemValue {
    let mainTitle: String
    let subTitle: String?
    let parentId: UUID?
    
    let order: Int
    
    var rgbRed: Float
    var rgbGreen: Float
    var rgbBlue: Float
}

struct SettingListItemValueList<Element: Hashable>: SettingItemValue {
    let mainTitle: String
    let subTitle: String?
    let parentId: UUID?
    
    let order: Int
    
    var list: [Element]
}

struct SettingListItemValueImage<Element: Hashable>: SettingItemValue {
    let mainTitle: String
    let subTitle: String?
    let parentId: UUID?
    
    let order: Int
    
    var imageData: Data?
}

protocol SettingItemValue {
    /// 같으면 한 그룹으로 인식
    var mainTitle: String { get }
    var subTitle: String? { get }
    var parentId: UUID? { get }
    
    var order: Int { get }
}

extension SettingListItem: Equatable {
    static func == (lhs: SettingListItem, rhs: SettingListItem) -> Bool {
        lhs.id == rhs.id
    }
}
