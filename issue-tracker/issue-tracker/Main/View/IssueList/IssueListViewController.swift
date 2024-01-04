//
//  IssueListViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/20.
//

import RxCocoa
import ReactorKit

final class IssueListViewController: UIViewController, View, ListViewRepresentingStatus {
    
    typealias Reactor = IssueListReactor
    
    private lazy var refreshControl = UIRefreshControl(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 20)))
    private var tableView = UITableView()
    var listItemSelected: PublishSubject<ListType>?
    var disposeBag = DisposeBag()
    
    private var issueListColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        tableView.accessibilityIdentifier = "issueListViewController"
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callSetting()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        callSetting()
        
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
        
        reactor.pulse(\.$issues).asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(
                cellIdentifier: IssueListTableViewCell.reuseIdentifier,
                cellType: IssueListTableViewCell.self
            )) { [weak self] _, entity, cell in
                cell.setEntity(entity)
                if let color = self?.issueListColor {
                    cell.setBackgroundColor(color)
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .bind(onNext: { event in
                (event.cell as? IssueListTableViewCell)?.setLayout()
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let id = self?.reactor?.currentState.issues[indexPath.row].id else {
                    return
                }
                
                self?.listItemSelected?.onNext(ListType.issue(id))
            })
            .disposed(by: disposeBag)
        
        refreshList()
        
        reactor.pulse(\.$issueStatus)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] status in
                self?.refreshControl.endRefreshing()
                
                guard let parent = (self?.parent as? MainListViewController), parent.listSegmentedControl.selectedSegmentIndex == 0 else {
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
    
    var statusDescription: String {
        reactor?.currentState.issueStatus ?? "0/0"
    }
}

extension IssueListViewController: SettingProxy {
    func callSetting() {
        let model = MainListCallSettingModel<SettingItemColor>()
        model.settingTitle = "M_ST_SVC_TCELL_CONTENTS_LIST_ISSUE_BGCOLOR".localized
        
        if let settingItem = model.settingValue {
            issueListColor = UIColor(settingItem: settingItem)
        }
    }
}
