//
//  MilestoneListViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/29.
//

import SnapKit
import RxSwift
import RxCocoa
import UIKit

class MilestoneListViewController: UIViewController, ViewBinding {
    
    private lazy var refreshControl = UIRefreshControl(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 20)))
    private var tableView = UITableView()
    private var disposeBag = DisposeBag()
    
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
        
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        tableView.refreshControl = self.refreshControl
        refreshControl.addTarget(self, action: #selector(reloadTableView(_:)), for: .valueChanged)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        tableView.register(MilestoneListTableViewCell.self, forCellReuseIdentifier: MilestoneListTableViewCell.reuseIdentifier)
        
        model?.requestIssueList() { [weak self] entity in
            guard let self = self, let entity = entity else {
                return
            }

            let cellType = MilestoneListTableViewCell.self
            let identifier = cellType.reuseIdentifier
            
            DispatchQueue.main.async {
                Observable<[MilestoneListEntity]>
                    .just(entity.openedMilestones + entity.closedMilestones)
                    .bind(to: self.tableView.rx.items(cellIdentifier: identifier, cellType: cellType)) { index, entity, cell in
                        cell.setEntity(entity)
                        cell.setLayout()
                    }
                    .disposed(by: self.disposeBag)
            }
        }
    }
    
    @objc func reloadTableView(_ sender: Any) {
        model?.requestIssueList() { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.tableView.refreshControl?.endRefreshing()
            }
        }
    }
}

extension MilestoneListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/7
    }
}
