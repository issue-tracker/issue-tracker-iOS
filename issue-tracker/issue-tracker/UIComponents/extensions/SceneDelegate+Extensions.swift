//
//  SceneDelegate+Extensions.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/25.
//

import UIKit

extension UIViewController {
    func switchScreen(type: MainView) {
        DispatchQueue.main.async {
            SceneDelegate.shared?.switchScreen(type: type)
        }
    }
}

extension SceneDelegate {
    static var shared: SceneDelegate? {
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)
    }
}
