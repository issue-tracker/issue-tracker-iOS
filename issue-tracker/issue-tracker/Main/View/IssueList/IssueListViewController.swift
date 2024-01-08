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
    typealias CELL = IssueListTableViewCell
    
    private lazy var refreshControl = UIRefreshControl(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 20)))
    private var tableView = UITableView()
    var listItemRelay: PublishRelay<Int>?
    var disposeBag = DisposeBag()
    
    private var issueListColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        tableView.accessibilityIdentifier = "issueListViewController"
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.register(CELL.self,
            forCellReuseIdentifier: CELL.reuseIdentifier)
        
        refreshControl.addTarget(self,
            action: #selector(refreshList),
            for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callSetting()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if let vc = parent as? MainListViewController {
            view.frame.size = vc.listScrollView.frame.size
            tableView.rowHeight = vc.listScrollView.frame.height / 4.5
        }
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
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
            .compactMap({ [weak self] ip -> Int? in
                self?.reactor?.currentState.issues[ip.row].id
            })
            .subscribe(onNext: { [weak self] id in
                self?.listItemRelay?.accept(id)
            })
            .disposed(by: disposeBag)
        
        refreshList()
        
        reactor.pulse(\.$issueStatus)
            .filter({ [weak self] _ in
                let parent = (self?.parent as? MainListViewController)
                let segmented = parent?.listSegmentedControl
                return segmented?.selectedSegmentIndex == 0
            })
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] status in
                self?.refreshControl.endRefreshing()
                self?.parent?.title = status
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
