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
        let button = UIButton(primaryAction: UIAction(handler: { action in
            self.navigationController?.pushViewController(IssueEditViewController(), animated: true)
        }))
        button.setBackgroundImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        
        return button
    }()
    
    private var model: IssueListRequestModel? = {
        guard let url = URL.apiURL else {
            return nil
        }
        
        return IssueListRequestModel(url)
    }()
    
    lazy var bindableHandler: ((Any?, ViewBindable) -> Void)? = { modelResult, bindable in
        if bindable is IssueListRequestModel, let result = modelResult as? [IssueListEntity] {
            
            DispatchQueue.main.async {
                let cellCount: Int = (self.model?.issueList.count ?? 0)
                
                if cellCount <= 20 {
                    self.model?.requestIssueList()
                }
                
                if cellCount - result.count == 0 {
                    self.tableView.reloadData()
                } else {
                    var indexPaths = [IndexPath]()
                    for i in 0..<result.count {
                        indexPaths.append(IndexPath(row: cellCount-result.count+i, section: 0))
                    }
                    
                    self.tableView.performBatchUpdates {
                        self.tableView.insertRows(at: indexPaths, with: .none)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model?.binding = self
        
        defer {
            view.bringSubviewToFront(plusButton)
        }
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.opaqueSeparator
        view.addSubview(tableView)
        view.addSubview(plusButton)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        plusButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
        
        view.layoutIfNeeded()
        tableView.dataSource = self
        tableView.delegate = self
        model?.requestIssueList()
    }
}

extension IssueListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model?.issueList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let label = UILabel()
        label.text = "test"
        cell.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return cell
    }
}

extension IssueListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.cellForRow(at: indexPath)?.layoutIfNeeded()
        return 80
    }
}
