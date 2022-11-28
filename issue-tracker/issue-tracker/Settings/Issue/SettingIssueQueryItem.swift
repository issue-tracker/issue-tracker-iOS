//
//  SettingIssueQueryItem.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/20.
//

import Foundation

struct SettingIssueQueryItem: Codable, Equatable {
    var id: UUID = UUID()
    var query: String
    var isOn: Bool = false
    var index: Int = 0
    
    static func == (lhs: SettingIssueQueryItem, rhs: SettingIssueQueryItem) -> Bool {
        return lhs.id == rhs.id
    }
}

enum QueryStatusColor {
    case activeColor
    case deActiveColor
    
    func getColorName() -> String {
        switch self {
        case .activeColor:
            return "query_status_active"
        case .deActiveColor:
            return "query_status_deactive"
        }
    }
}
