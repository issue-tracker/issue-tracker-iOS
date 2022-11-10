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
        
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.frame = view.frame
        tableView.register(LabelListTableViewCell.self, forCellReuseIdentifier: LabelListTableViewCell.reuseIdentifier)
    }
    
    func bind(reactor: LabelListReactor) {
        
        refreshControl.rx.controlEvent(.valueChanged).map({ Reactor.Action.reloadLabel })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isRefreshing).asObservable()
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        tableView.rowHeight = view.frame.height/8.5
        
        reactor.pulse(\.$labels).asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(
                cellIdentifier: LabelListTableViewCell.reuseIdentifier,
                cellType: LabelListTableViewCell.self
            )) { index, entity, cell in
                cell.setEntity(entity)
                cell.setLayout()
            }
            .disposed(by: disposeBag)
        
        reactor.requestInitialList()
    }
}
