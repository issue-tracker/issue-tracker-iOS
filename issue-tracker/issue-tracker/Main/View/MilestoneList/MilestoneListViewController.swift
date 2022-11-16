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
        
        tableView.accessibilityIdentifier = "milestoneListViewController"
        tableView.separatorStyle = .none
        tableView.refreshControl = self.refreshControl
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        let parent = parent as? MainListViewController
        var parentViewFrame = parent?.listScrollView.frame ?? view.frame
        parentViewFrame.origin = .zero
        tableView.frame = parentViewFrame
        
        parentViewFrame.origin = CGPoint(x: (parentViewFrame.width * 2), y: 0)
        view.frame = parentViewFrame
        
        tableView.rowHeight = parentViewFrame.height/7
        tableView.register(MilestoneListTableViewCell.self, forCellReuseIdentifier: MilestoneListTableViewCell.reuseIdentifier)
        
        view.setNeedsLayout()
        reactor = Reactor()
    }
    
    func bind(reactor: MilestoneListReactor) {

        refreshControl.rx.controlEvent(.valueChanged).map({ Reactor.Action.reloadMilestone })
            .timeout(.seconds(3), scheduler: ConcurrentMainScheduler.instance)
            .do(onCompleted: { [weak self] in self?.refreshControl.endRefreshing() })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isRefreshing).asObservable()
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$milestones).asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(
                cellIdentifier: MilestoneListTableViewCell.reuseIdentifier,
                cellType: MilestoneListTableViewCell.self
            )) { index, entity, cell in
                cell.setEntity(entity)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .bind(onNext: { event in
                (event.cell as? MilestoneListTableViewCell)?.setLayout()
            })
            .disposed(by: disposeBag)
        
        refreshList()
        
        reactor.pulse(\.$milestoneStatus)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] status in
                self?.refreshControl.endRefreshing()
                
                guard let parent = (self?.parent as? MainListViewController), parent.listSegmentedControl.selectedSegmentIndex == 2 else {
                    return
                }
                
                parent.title = status
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    private func refreshList() {
        reactor?.requestInitialList()
    }
}
