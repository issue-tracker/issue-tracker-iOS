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
        
        UserDefaults.standard.setValue(
            (try? JSONEncoder().encode([
                SettingIssueList(title: "직접 입력", imageURL: "issue_list_1".createLocalURL, isActivated: true),
                SettingIssueList(title: "입력된 값 사용", imageURL: "issue_list_2".createLocalURL, isActivated: false)
            ])),
            forKey: IssueSettings.list.getPersistentKey()
        )
        
        UserDefaults.standard.setValue(
            (try? JSONEncoder().encode([
                SettingIssueQueryItem(query: "is:open", isOn: true),
                SettingIssueQueryItem(query: "label:testLabel", isOn: true),
                SettingIssueQueryItem(query: "visibility:visible", isOn: true),
                SettingIssueQueryItem(query: "is:close"),
                SettingIssueQueryItem(query: "label:noTestLabel"),
                SettingIssueQueryItem(query: "visibility:inVisible")
            ])),
            forKey: IssueSettings.query.getPersistentKey()
        )
        
        return true
    }
    
    var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        self.orientationLock
    }
}

