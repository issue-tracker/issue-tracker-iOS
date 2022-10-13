//
//  AppDelegate.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/11.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let initialSettings = [
            SettingIssueList(title: "직접 입력", imageURL: "issue_list_1".createLocalURL, isActivated: true),
            SettingIssueList(title: "입력된 값 사용", imageURL: "issue_list_2".createLocalURL, isActivated: false)
        ]
        
        let encoded = try? JSONEncoder().encode(initialSettings)
        
        UserDefaults.standard.setValue(encoded, forKey: "SettingIssueList")
        return true
    }
    
    var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        self.orientationLock
    }
}

