//
//  SceneDelegate.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/11.
//

import UIKit

enum MainView {
    case login
    case main
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private let loginNav = LoginNavigationController()
    private let loginVC = LoginViewController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        switchScreen(type: .login)
    }
    
    func switchScreen(type: MainView) {
        switch type {
        case .login:
            window?.rootViewController = getLoginNavigationView()
            window?.makeKeyAndVisible()
        case .main:
            window?.rootViewController = getIssueListTabBarView()
            window?.makeKeyAndVisible()
        }
        
        if let window = window {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        }
    }
    
    private func getLoginNavigationView() -> UINavigationController {
        let loginNav = LoginNavigationController()
        let loginVC = LoginViewController()
        loginNav.setViewControllers([loginVC], animated: false)
        return loginNav
    }
    
    private func getIssueListTabBarView() -> UITabBarController {
        let tabBar = MainTabBarController()
        
        let issueListNav = IssueListNavigationController(rootViewController: IssueListViewController())
        let myPageNav = MyPageNavigationController(rootViewController: MyPageViewController())
        let settingsNav = SettingsNavigationController(rootViewController: SettingsViewController())
        
        issueListNav.tabBarItem.title = "List"
        issueListNav.tabBarItem.image = UIImage(systemName: "list.dash")
        
        myPageNav.tabBarItem.title = "MyPage"
        myPageNav.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        
        settingsNav.tabBarItem.title = "Settings"
        settingsNav.tabBarItem.image = UIImage(systemName: "gear")
        
        tabBar.viewControllers = [issueListNav, myPageNav, settingsNav]
        
        return tabBar
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        print(URLContexts.first?.url.absoluteString ?? "Deep Link Detected!")
    }
}
