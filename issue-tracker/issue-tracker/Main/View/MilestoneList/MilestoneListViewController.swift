//
//  MilestoneListViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/29.
//

import SnapKit
import UIKit

class MilestoneListViewController: UIViewController, ViewBinding {
    
    private var tableView = UITableView()
    
    private var model: MainViewSingleRequestModel<AllMilestoneEntity>? = {
        guard let url = URL.milestoneApiURL else {
            return nil
        }
        
        return MainViewSingleRequestModel(url)
    }()
    
    var modelStatusCount: String {
        if let entity = model?.entity {
            return "\(entity.openedMilestones.count)/\(entity.openedMilestones.count+entity.closedMilestones.count)"
        }
        
        return "0/0"
    }
    
    private var entities: AllMilestoneEntity? {
        self.model?.entity
    }
    
    private var openedMilestone: [MilestoneListEntity] {
        model?.entity?.openedMilestones ?? []
    }
    private var closedMilestone: [MilestoneListEntity] {
        model?.entity?.closedMilestones ?? []
    }
    private var allMilestone: [MilestoneListEntity] {
        openedMilestone + closedMilestone
    }
    
    lazy var bindableHandler: ((Any?, ViewBindable) -> Void)? = { [weak self] _, bindable in
        guard let self = self, bindable is MainViewSingleRequestModel<AllMilestoneEntity> else {
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
        
        tableView.register(MilestoneListTableViewCell.self, forCellReuseIdentifier: MilestoneListTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension MilestoneListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allMilestone.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MilestoneListTableViewCell.reuseIdentifier, for: indexPath) as? MilestoneListTableViewCell else {
            
            return UITableViewCell()
        }
        
        cell.setEntity(allMilestone[indexPath.row])
        cell.setLayout()
        return cell
    }
}

extension MilestoneListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/7
    }
}
