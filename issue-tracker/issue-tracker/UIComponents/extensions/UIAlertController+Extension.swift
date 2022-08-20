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
    
    static func getCommonAlert(_ message: String = "") -> UIAlertController {
        return message.getDefaultAlertController()
    }
}

extension UIAlertController {
    static var commonAlert: ((String) -> UIAlertController) = {
        return $0.getDefaultAlertController()
    }
}

// String --> message
private extension String {
    func getDefaultAlertController(title: String? = "경고", actionTitle: String? = "확인") -> UIAlertController {
        let alertController = UIAlertController(title: title, message: self, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: .cancel, handler: { _ in
            alertController.dismiss(animated: true)
        }))
        return alertController
    }
}
