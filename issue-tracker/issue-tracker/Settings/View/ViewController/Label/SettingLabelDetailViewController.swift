//
//  SettingLabelDetailViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/14.
//

import Foundation
import UIKit

class SettingLabelDetailViewController: UIViewController {
    private(set) var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        
        navigationItem.title = "Detail"
        label.text = "SettingLabelDetailViewController"
        
        label.snp.makeConstraints { make in
            make.center.equalTo(self.view.snp.center)
        }
    }
}
