//
//  SettingViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import ReactorKit

fileprivate typealias CELL = SettingTableViewCell
fileprivate typealias TITLECELL = SettingTableViewTitleCell

class SettingViewController: CommonProxyViewController, View {
    typealias Reactor = SettingReactor
    
    var disposeBag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.register(TITLECELL.self, forCellReuseIdentifier: TITLECELL.reuseIdentifier)
        view.register(CELL.self, forCellReuseIdentifier: CELL.reuseIdentifier)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        // 상세 화면에서 다시 돌아왔을 때 기존의 상태값을 유지하도록 하기 위함.
        if reactor == nil {
            reactor = Reactor()
        }
    }
    
    func bind(reactor: SettingReactor) {
        tableView.rx.itemSelected
            .map({ Reactor.Action.updateItemIntiate($0) })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$settingList)
            .bind(to: tableView.rx.items(
                cellIdentifier: CELL.reuseIdentifier,
                cellType: CELL.self)
            ) { row, element, cell in
                cell.label.text = element.mainTitle
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$updatingId)
            .compactMap({$0})
            .bind(onNext: { [weak self] id in
                self?.goNextView(id)
            })
            .disposed(by: disposeBag)
    }
    
    private func goNextView(_ id: UUID) {
        let view = SettingDetailViewController()
        view.parentReactor = reactor
        view.targetId = id
        // CoreData를 적용하기 전까지의 임시 코드
        view.settingList = reactor?.allItems ?? []
        
        navigationController?.pushViewController(view, animated: true)
    }
}

extension SettingListType {
    func toIndent() -> String {
        (0..<self.rawValue).map({_ in "   "}).reduce("", +)
    }
}
