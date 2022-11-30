//
//  CommonProxyViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/20.
//

import UIKit

class CommonProxyViewController: UIViewController {
    
    private var resignKeyboardGesture: UIGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        (self as? SettingProxyViewController)?.callSetting()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let resignKeyboardGesture = resignKeyboardGesture {
            view.removeGestureRecognizer(resignKeyboardGesture)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
    
    @discardableResult
    func makeSuperViewResignKeyboard() -> UIGestureRecognizer {
        let result = UITapGestureRecognizer(target: self, action: #selector(resignKeyboard))
        self.resignKeyboardGesture = result
        view.addGestureRecognizer(result)
        return result
    }
    
    @objc func resignKeyboard() {
        self.view.endEditing(true)
    }
}
