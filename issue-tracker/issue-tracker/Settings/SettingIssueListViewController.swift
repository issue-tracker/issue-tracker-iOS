//
//  SettingIssueListViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/06.
//

import SnapKit
import UIKit

class SettingIssueListViewController: UIViewController {
    private(set) var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        navigationItem.title = "Issue"
        label.text = "SettingIssueListViewController"
        
        label.snp.makeConstraints { make in
            make.center.equalTo(self.view.snp.center)
        }
    }
}
