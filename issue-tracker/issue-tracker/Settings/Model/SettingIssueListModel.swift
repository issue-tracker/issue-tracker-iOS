//
//  SettingIssueListModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/13.
//

import Foundation

class SettingIssueListModel {
    private var issueListCases: [SettingIssueList] = []
    
    private var decoded: (Data) -> [SettingIssueList] = { data in
        (try? JSONDecoder().decode([SettingIssueList].self, from: data)) ?? []
    }
    
    private var encoded: ([SettingIssueList]) -> Data = { list in
        (try? JSONEncoder().encode(list)) ?? Data()
    }
    
    init() {
        if let data = UserDefaults.standard.object(forKey: "SettingIssueList") as? Data {
            issueListCases = decoded(data)
        }
    }
    
    func settingCount() -> Int {
        issueListCases.count
    }
    
    func getItem(index: Int) -> SettingIssueList {
        issueListCases[index]
    }
    
    @discardableResult
    func setIssueItem(title: String, value: Bool) -> Bool {
        guard let data = UserDefaults.standard.object(forKey: "SettingIssueList") as? Data else {
            return false
        }
        
        var list = decoded(data)
        
        if let targetIndex = list.firstIndex(where: {$0.title == title}) {
            for (index, _) in list.enumerated() {
                if targetIndex == index {
                    list[index].isActivated.toggle()
                    break
                }
            }
        }
        
        issueListCases = list
        UserDefaults.standard.setValue(encoded(list), forKey: "SettingIssueList")
        
        return false
    }
}

struct SettingIssueList: Codable {
    var title: String
    var imageURL: URL?
    var isActivated: Bool
}
