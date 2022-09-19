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
    
    func showErrorIfExists(title: String? = "경고", data: Data, actionTitle: String? = "확인", handler: ((UIAlertAction) -> Void)? = nil) -> Bool {
        var message: String?
        
        defer {
            if let message = message {
                self.commonAlert(title: title, message, actionTitle: actionTitle, handler: handler)
            }
        }
        
        let model = HTTPResponseModel()
        if let decodedMessage = model.getDecoded(from: data, as: String.self) {
            message = decodedMessage
        } else if let decodedMessage = model.getMessageResponse(from: data) {
            message = decodedMessage
        }
        
        return message != nil
    }
    
    func switchScreen(type: MainView) {
        DispatchQueue.main.async {
            ((UIApplication.shared.connectedScenes.first as? UIWindowScene)?.delegate as? SceneDelegate)?.switchScreen(type: type)
        }
    }
}
