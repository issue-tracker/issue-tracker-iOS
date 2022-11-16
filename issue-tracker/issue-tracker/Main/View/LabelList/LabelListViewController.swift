//
//  LabelListViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/29.
//

import RxCocoa
import ReactorKit

final class LabelListViewController: UIViewController, View {
    
    typealias Reactor = LabelListReactor
    
    private lazy var refreshControl = UIRefreshControl(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 20)))
    private var tableView = UITableView()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        tableView.accessibilityIdentifier = "labelListViewController"
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        let parent = parent as? MainListViewController
        var parentViewFrame = parent?.listScrollView.frame ?? view.frame
        parentViewFrame.origin = .zero
        tableView.frame = parentViewFrame
        
        parentViewFrame.origin = CGPoint(x: parentViewFrame.width, y: 0)
        view.frame = parentViewFrame
        
        tableView.rowHeight = parentViewFrame.height/8.5
        tableView.register(LabelListTableViewCell.self, forCellReuseIdentifier: LabelListTableViewCell.reuseIdentifier)
        
        view.setNeedsLayout()
        reactor = Reactor()
    }
    
    func bind(reactor: LabelListReactor) {
        
        reactor.pulse(\.$isRefreshing)
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$labels).asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(
                cellIdentifier: LabelListTableViewCell.reuseIdentifier,
                cellType: LabelListTableViewCell.self
            )) { index, entity, cell in
                cell.setEntity(entity)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .bind(onNext: { event in
                (event.cell as? LabelListTableViewCell)?.setLayout()
            })
            .disposed(by: disposeBag)
        
        refreshList()
        
        reactor.pulse(\.$labelStatus)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] status in
                self?.refreshControl.endRefreshing()
                
                guard let parent = (self?.parent as? MainListViewController), parent.listSegmentedControl.selectedSegmentIndex == 1 else {
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
