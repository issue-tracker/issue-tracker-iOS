//
//  SettingsIssueDetailViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/07.
//

import Foundation
import UIKit

class SettingIssueDetailViewController: UIViewController {
    private(set) var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(label)
        
        navigationItem.title = "Detail"
        label.text = "SettingIssueDetailViewController"
        
        label.snp.makeConstraints { make in
            make.center.equalTo(self.view.snp.center)
        }
    }
}
