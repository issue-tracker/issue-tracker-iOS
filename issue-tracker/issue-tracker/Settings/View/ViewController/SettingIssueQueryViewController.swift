//
//  SettingIssueQueryViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/07.
//

import Foundation
import UIKit

/// UITableView EditMode 이용해서 적용할 쿼리와 적용하지 않을 쿼리를 설정할 수 있도록 함.
///
/// 삭제 추가가 가능하게 해야할지는 잘 모르겠음.
class SettingIssueQueryViewController: UIViewController {
    private(set) var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        
        navigationItem.title = "Query"
        label.text = "SettingIssueQueryViewController"
        
        label.snp.makeConstraints { make in
            make.center.equalTo(self.view.snp.center)
        }
    }
}
