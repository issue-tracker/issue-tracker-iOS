//
//  SceneDelegate.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/11.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private let loginNav = LoginNavigationController()
    private let loginVC = LoginViewController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        loginNav.setViewControllers([loginVC], animated: false)
        window?.rootViewController = loginNav
        window?.makeKeyAndVisible()
    }
}

