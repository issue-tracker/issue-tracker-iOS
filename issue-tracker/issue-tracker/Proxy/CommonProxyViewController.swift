//
//  CommonProxyViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/20.
//

import UIKit

class CommonProxyViewController: SettingProxyViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignKeyboard)))
        callSetting()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
    
    @objc func resignKeyboard() {
        self.view.endEditing(true)
    }
}
