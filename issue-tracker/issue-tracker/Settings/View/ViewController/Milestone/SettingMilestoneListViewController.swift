//
//  SettingMilestoneListViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/14.
//

import Foundation
import UIKit

class SettingMilestoneListViewController: UIViewController {
    private(set) var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        
        navigationItem.title = "List"
        label.text = "SettingMilestoneListViewController"
        
        label.snp.makeConstraints { make in
            make.center.equalTo(self.view.snp.center)
        }
    }
}
