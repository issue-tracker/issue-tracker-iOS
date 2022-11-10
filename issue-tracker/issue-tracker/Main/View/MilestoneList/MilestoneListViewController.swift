//
//  MilestoneListViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/29.
//

import RxCocoa
import ReactorKit

final class MilestoneListViewController: UIViewController, View {
    
    typealias Reactor = MilestoneListReactor
    
    private lazy var refreshControl = UIRefreshControl(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 20)))
    private var tableView = UITableView()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        tableView.separatorStyle = .none
        tableView.refreshControl = self.refreshControl
        tableView.frame = view.frame
        tableView.register(MilestoneListTableViewCell.self, forCellReuseIdentifier: MilestoneListTableViewCell.reuseIdentifier)
    }
    
    func bind(reactor: MilestoneListReactor) {

        refreshControl.rx.controlEvent(.valueChanged).map({ Reactor.Action.reloadMilestone })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isRefreshing).asObservable()
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        tableView.rowHeight = view.frame.height/7
        
        reactor.pulse(\.$milestones).asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(
                cellIdentifier: MilestoneListTableViewCell.reuseIdentifier,
                cellType: MilestoneListTableViewCell.self
            )) { index, entity, cell in
                cell.setEntity(entity)
                cell.setLayout()
            }
            .disposed(by: disposeBag)
        
        reactor.requestInitialList()
    }
}
