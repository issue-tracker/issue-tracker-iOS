//
//  IssueListViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/20.
//

import SnapKit

class IssueListViewController: CommonProxyViewController, ViewBinding {
    
    private var tableView = UITableView()
    
    private var model: MainViewRequestModel<IssueListEntity>? = {
        guard let url = URL.apiURL else {
            return nil
        }
        
        return MainViewRequestModel(url)
    }()
    
    private var entities: [IssueListEntity]? {
        self.model?.entityList
    }
    
    lazy var bindableHandler: ((Any?, ViewBindable) -> Void)? = { modelResult, bindable in
        if bindable is MainViewRequestModel<IssueListEntity>, let result = modelResult as? [IssueListEntity] {
            
            DispatchQueue.main.async {
                var cellCount: Int { self.entities?.count ?? 0 }
                
                if cellCount <= 20 {
                    self.model?.requestIssueList()
                }
                
                guard cellCount - result.count != 0 else {
                    self.tableView.reloadData()
                    return
                }
                
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model?.binding = self
        
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.layoutIfNeeded()
        
        tableView.register(IssueListTableViewCell.self, forCellReuseIdentifier: IssueListTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension IssueListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        entities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IssueListTableViewCell.reuseIdentifier, for: indexPath) as? IssueListTableViewCell else {
            
            let normalCell = UITableViewCell()
            let label = UILabel()
            label.text = "test"
            normalCell.contentView.addSubview(label)
            label.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            return normalCell
        }
        
        if let entity = entities?[indexPath.row] {
            cell.bindableHandler?(entity, self)
        }
        
        cell.setLayout()
        cell.profileView.touchHandler = {
            // TODO: Define touch action.
        }
        
        return cell
    }
}

extension IssueListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/4.5
    }
}
