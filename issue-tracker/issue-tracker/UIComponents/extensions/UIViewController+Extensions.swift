//
//  UIViewController+Extensions.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/22.
//

import UIKit

extension UIViewController {
    func commonAlert(title: String? = "경고", _ message: String = "", actionTitle: String? = "확인", handler: ((UIAlertAction) -> Void)? = nil) {
        DispatchQueue.main.async {
            self.present(UIAlertController.getCommonAlert(title: title, message, handler: handler), animated: true)
        }
    }
    
    func switchScreen(type: MainView) {
        DispatchQueue.main.async {
            ((UIApplication.shared.connectedScenes.first as? UIWindowScene)?.delegate as? SceneDelegate)?.switchScreen(type: type)
        }
    }
}
