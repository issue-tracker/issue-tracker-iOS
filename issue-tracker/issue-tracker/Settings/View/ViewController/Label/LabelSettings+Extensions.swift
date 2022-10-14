//
//  LabelSettings+Extensions.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/14.
//

import UIKit

extension LabelSettings: SettingCategory {
    
    func getNextView() -> UIViewController {
        switch self {
        case .list:
            return SettingLabelListViewController()
        case .query:
            return SettingLabelQueryViewController()
        case .detail:
            return SettingLabelDetailViewController()
        }
    }
    
    func getName() -> String {
        self.rawValue
    }
}
