//
//  IssueListViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/20.
//

import RxCocoa
import ReactorKit

final class IssueListViewController: UIViewController, View {
    
    typealias Reactor = IssueListReactor
    
    private lazy var refreshControl = UIRefreshControl(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 20)))
    private var tableView = UITableView()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        tableView.accessibilityIdentifier = "issueListViewController"
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        let parent = parent as? MainListViewController
        var parentViewFrame = parent?.listScrollView.frame ?? view.frame
        parentViewFrame.origin = .zero
        tableView.frame = parentViewFrame
        view.frame = parentViewFrame
        
        tableView.rowHeight = parentViewFrame.height / 4.5
        tableView.register(IssueListTableViewCell.self, forCellReuseIdentifier: IssueListTableViewCell.reuseIdentifier)
        
        reactor = Reactor()
    }
    
    func bind(reactor: IssueListReactor) {
        
        refreshControl.rx.controlEvent(.valueChanged).map({ Reactor.Action.reloadIssue })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isRefreshing).asObservable()
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$issues).asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(
                cellIdentifier: IssueListTableViewCell.reuseIdentifier,
                cellType: IssueListTableViewCell.self
            )) { _, entity, cell in
                cell.setEntity(entity)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .bind(onNext: { event in
                (event.cell as? IssueListTableViewCell)?.setLayout()
            })
            .disposed(by: disposeBag)
        
        reactor.requestInitialList()
    }
}
