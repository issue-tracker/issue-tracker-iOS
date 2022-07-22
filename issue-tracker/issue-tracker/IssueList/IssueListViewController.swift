//
//  IssueListViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/20.
//

import UIKit
import SnapKit

class IssueListViewController: CommonProxyViewController {
    
    private var tableView = UITableView()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)), primaryAction: UIAction(handler: { action in
            self.navigationController?.pushViewController(IssueEditViewController(), animated: true)
        }))
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defer {
            view.bringSubviewToFront(plusButton)
        }
        
        view.addSubview(tableView)
        view.addSubview(plusButton)
        
        tableView.snp.makeConstraints { make in
            make.center.equalTo(self.view.snp.center)
        }
        
        plusButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(16)
        }
        
        view.layoutIfNeeded()
    }
}

extension IssueListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
