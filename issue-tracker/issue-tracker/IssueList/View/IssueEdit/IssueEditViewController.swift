//
//  IssueEditViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/21.
//

import UIKit

enum IssueEditType {
    case add
    case update
}

class IssueEditViewController: UIViewController {

    var editType: IssueEditType = .add
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
