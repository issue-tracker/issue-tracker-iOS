//
//  Milestone+Extensions.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/14.
//

import UIKit

extension MilestoneSettings: SettingCategory {
    
    func getNextView() -> UIViewController {
        switch self {
        case .list:
            return SettingMilestoneListViewController()
        case .query:
            return SettingMilestoneQueryViewController()
        }
    }
    
    func getName() -> String {
        self.rawValue
    }
}
