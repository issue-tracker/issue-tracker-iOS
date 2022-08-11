//
//  IssueListViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/20.
//

import UIKit
import SnapKit

class IssueListViewController: CommonProxyViewController, ViewBinding {
    
    private var tableView = UITableView()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)), primaryAction: UIAction(handler: { action in
            self.navigationController?.pushViewController(IssueEditViewController(), animated: true)
        }))
        
        return button
    }()
    
    private var model: IssueListRequestModel? = {
        guard let url = URL.apiURL else {
            return nil
        }
        
        return IssueListRequestModel(url)
    }()
    
    lazy var bindableHandler: ((Any?, ViewBindable) -> Void)? = { modelResult, bindable in
        if bindable is IssueListRequestModel {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model?.binding = self
        
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
        tableView.dataSource = self
    }
}

extension IssueListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model?.issueList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
