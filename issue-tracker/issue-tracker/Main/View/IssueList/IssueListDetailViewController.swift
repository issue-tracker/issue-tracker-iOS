//
//  IssueListDetailViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/08.
//

import UIKit

class IssueListDetailViewController: UIViewController {
    
    private var entity: IssueListEntity?
    
    convenience init(_ entity: IssueListEntity) {
        self.init()
        self.entity = entity
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = entity?.title
    }
    
    func setEntity(_ entity: IssueListEntity) {
        self.entity = entity
    }
}
