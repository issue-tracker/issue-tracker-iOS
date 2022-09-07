//
//  IssueListViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/20.
//

import SnapKit

class IssueListViewController: UIViewController, ViewBinding, ViewBindable {
    
    private var tableView = UITableView()
    
    private var model: MainViewSingleRequestModel<AllIssueEntity>? = {
        guard let url = URL.issueApiURL else {
            return nil
        }
        
        return MainViewSingleRequestModel(url)
    }()
    var modelStatusCount: String {
        if let entity = model?.entity {
            return "\(entity.openIssues.count)/\(entity.openIssues.count+entity.closedIssues.count)"
        }
        return "0/0"
    }
    
    private var openIssues: [IssueListEntity] {
        model?.entity?.openIssues ?? []
    }
    private var closedIssues: [IssueListEntity] {
        model?.entity?.closedIssues ?? []
    }
    private var allIssues: [IssueListEntity] {
        openIssues + closedIssues
    }
    
    var binding: ViewBinding?
    
    lazy var bindableHandler: ((Any?, ViewBindable) -> Void)? = { [weak self] _, bindable in
        guard let self = self, bindable is MainViewSingleRequestModel<AllIssueEntity> else {
            return
        }
        
        self.binding?.bindableHandler?(self.model?.entity, self)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model?.binding = self
        model?.builder.setURLQuery(["page":"0"])
        model?.requestIssueList()
        
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
        allIssues.count
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
        
        cell.bindableHandler?(allIssues[indexPath.row], self)
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
