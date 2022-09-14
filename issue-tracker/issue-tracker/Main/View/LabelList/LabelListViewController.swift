//
//  LabelListViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/29.
//

import SnapKit
import UIKit

class LabelListViewController: UIViewController, ViewBinding {
    
    private var tableView = UITableView()
    
    private var model: MainViewRequestModel<LabelListEntity>? = {
        guard let url = URL.labelApiURL else {
            return nil
        }
        
        return MainViewRequestModel(url)
    }()
    
    var modelStatusCount: String {
        if let entityList = model?.entityList {
            return "\(entityList.count)"
        }
        return "0"
    }
    
    private var entities: [LabelListEntity] {
        self.model?.entityList ?? []
    }
    
    lazy var bindableHandler: ((Any?, ViewBindable) -> Void)? = { [weak self] _, bindable in
        guard let self = self, bindable is MainViewRequestModel<LabelListEntity> else {
            return
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model?.binding = self
//        model?.requestIssueList()
        
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.register(LabelListTableViewCell.self, forCellReuseIdentifier: LabelListTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension LabelListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        entities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LabelListTableViewCell.reuseIdentifier, for: indexPath) as? LabelListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setEntity(entities[indexPath.row])
        cell.setLayout()
        return cell
    }
}

extension LabelListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/8.5
    }
}
