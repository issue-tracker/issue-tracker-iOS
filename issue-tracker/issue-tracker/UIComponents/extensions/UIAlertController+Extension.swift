//
//  UIAlertController+Extension.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/29.
//

import UIKit

// 기본 알럿 창을 위한 UIAlertController extension.
extension UIAlertController {
    static var messageFailed: UIAlertController {
        let message = "요청하신 작업에 실패하였습니다."
        return message.getDefaultAlertController()
    }
    
    static var messageDeveloping: UIAlertController {
        let message = "현재 작업중인 기능입니다."
        return message.getDefaultAlertController()
    }
    
    static func getCommonAlert(title: String? = "경고", _ message: String = "", actionTitle: String? = "확인", handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        return message.getDefaultAlertController(title: title, actionTitle: actionTitle, handler: handler)
    }
    
    static func willProceed(title: String? = "경고", _ message: String = "", actionTitle: String? = "확인", handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "예", style: .default, handler: handler))
        alert.addAction(UIAlertAction(title: "아니오", style: .destructive, handler: { _ in
            alert.dismiss(animated: true)
        }))
        
        return alert
    }
}

extension UIAlertController {
    static var commonAlert: ((String) -> UIAlertController) = {
        return $0.getDefaultAlertController()
    }
}

// String --> message
private extension String {
    func getDefaultAlertController(title: String? = "경고", actionTitle: String? = "확인", handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: self, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: .cancel, handler: handler))
        return alertController
    }
}
