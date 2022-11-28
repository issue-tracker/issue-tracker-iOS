//
//  SettingProxyViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/20.
//

import UIKit

class SettingProxyViewController: UIViewController {
    
    var settingKeys: [String] {
        GeneralSettings.allCases.map({$0.getPersistentKey()})
        + IssueSettings.allCases.map({$0.getPersistentKey()})
        + LabelSettings.allCases.map({$0.getPersistentKey()})
        + MilestoneSettings.allCases.map({$0.getPersistentKey()})
    }
    
    var settingValues = [String: [SettingItemClickable]]()
    
    func callSetting() {
        settingValues.removeAll()
        
        settingKeys.forEach { key in
            settingValues[key] = (UserDefaults.standard.value(forKey: key) as? [SettingItemClickable]) ?? []
        }
    }
}
