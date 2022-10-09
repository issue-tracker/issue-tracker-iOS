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
    
    var topViewController: UIViewController? {
        (window?.rootViewController as? UINavigationController)?.topViewController
    }
    
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
            window?.rootViewController = getTabBarView()
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
        
        let issueListNav = MainListNavigationController(rootViewController: IssueListViewController())
        let myPageNav = MyPageNavigationController(rootViewController: MyPageViewController())
        let settingsNav = SettingsNavigationController(rootViewController: SettingsViewController())
        
        issueListNav.tabBarItem.title = "List"
        issueListNav.tabBarItem.accessibilityIdentifier = "List"
        issueListNav.tabBarItem.image = UIImage(systemName: "list.dash")
        
        myPageNav.tabBarItem.title = "MyPage"
        myPageNav.tabBarItem.accessibilityIdentifier = "MyPage"
        myPageNav.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        
        settingsNav.tabBarItem.title = "Settings"
        settingsNav.tabBarItem.accessibilityIdentifier = "Settings"
        settingsNav.tabBarItem.image = UIImage(systemName: "gear")
        
        tabBar.viewControllers = [issueListNav, myPageNav, settingsNav]
        
        return tabBar
    }
    
    private func getTabBarView() -> UITabBarController {
        let tabBar = MainTabBarController()
        
        let issueListNav = MainListNavigationController(rootViewController: MainListViewController())
        let myPageNav = MyPageNavigationController(rootViewController: MyPageViewController())
        let settingsNav = SettingsNavigationController(rootViewController: SettingsViewController())
        
        issueListNav.tabBarItem.title = "Main"
        issueListNav.tabBarItem.image = UIImage(systemName: "list.dash")
        
        myPageNav.tabBarItem.title = "MyPage"
        myPageNav.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        
        settingsNav.tabBarItem.title = "Settings"
        settingsNav.tabBarItem.image = UIImage(systemName: "gear")
        
        tabBar.viewControllers = [issueListNav, myPageNav, settingsNav]
        
        return tabBar
    }
    
    // React URI Scheme
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) { }
    
    // React Universal Link
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb else { // Check activity Universal Link.
            return
        }
        
        guard
            let userURL = userActivity.webpageURL,
            let allURLs = URL.allAuthenticationURLs,
            let service = userURL.getService(),
            let components = URLComponents(url: userURL, resolvingAgainstBaseURL: true)
        else {
            topViewController?.present(UIAlertController.messageFailed, animated: true)
            return
        }
        
        print(userURL)
        print(allURLs)
        print(service)
        print(components)
        // 2. signInMember가 올 경우는 이미 가입된 회원.
        // 3. signUpFormData가 올 경우는 가입해야 되는 회원.
    }
}

struct OAuthSignin: Encodable {
    let email: String
    let nickname: String
    let profileImage: String
    let authProviderType: String
    let resourceOwnerId: String
}
