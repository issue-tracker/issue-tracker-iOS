//
//  IssueSettings+Extensions.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/14.
//

import UIKit

extension IssueSettings: SettingCategory {
    
    func getNextView() -> UIViewController? {
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
