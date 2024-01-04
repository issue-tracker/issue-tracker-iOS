//
//  SceneDelegate.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/11.
//

import UIKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    enum MainView {
        case login
        case main
    }
    
    // MARK: - Helper methods
    
    var topViewController: UIViewController? {
        (window?.rootViewController as? UINavigationController)?.topViewController
    }
    
    func switchScreen(type: MainView) {
        var getRootView: () -> (UIViewController) {
            switch type {
            case .login: getLoginNavigationView
            case .main: getTabBarView
            }
        }
        
        window?.rootViewController = getRootView()
        window?.makeKeyAndVisible()
        
        if let window = window {
            UIView.transition(
                with: window,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: nil)
        }
    }
    
    private func getLoginNavigationView() -> UINavigationController {
        let loginNav = LoginNavigationController()
        loginNav.setViewControllers([LoginViewController()], animated: false)
        return loginNav
    }
    
    private func getTabBarView() -> UITabBarController {
        let tabBar = MainTabBarController()
        tabBar.viewControllers = [
            MainListNavigationController(rootViewController: MainListViewController())
                .setTabBaritem(as: "main", imageName: "list.dash"),
            MyPageNavigationController(rootViewController: MyPageViewController())
                .setTabBaritem(as: "myPage", imageName: "person.crop.circle"),
            SettingsNavigationController(rootViewController: SettingViewController())
                .setTabBaritem(as: "setting", imageName: "gear")
        ]
        
        return tabBar
    }
    
    // MARK: - SceneDelegate delegate methods
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        switchScreen(type: .login)
    }
    
    // Responds URI Scheme call
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) { }
    
    // Responds Universal Link call
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb else { // Check activity Universal Link.
            return
        }
        
        guard
            let userURL = userActivity.webpageURL,
            let _ = URL.allAuthenticationURLs,
            let _ = userURL.getService(),
            let _ = URLComponents(url: userURL, resolvingAgainstBaseURL: true)
        else {
            topViewController?.present(UIAlertController.messageFailed, animated: true)
            return
        }
        
        // 2. signInMember가 올 경우는 이미 가입된 회원.
        // 3. signUpFormData가 올 경우는 가입해야 되는 회원.
    }
}

private extension UINavigationController {
    func setTabBaritem(as title: String, imageName systemName: String) -> Self {
        tabBarItem.title = title
        tabBarItem.image = UIImage(systemName: systemName)
        return self
    }
}
