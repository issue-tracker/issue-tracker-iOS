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

class SettingViewController: CommonProxyViewController, View {
    typealias Reactor = SettingReactor
    typealias CELL = SettingTableViewCell
    
    var disposeBag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.register(CELL.self, forCellReuseIdentifier: CELL.reuseIdentifier)
        view.dataSource = self
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
        tableView.rowHeight = 60
        
        // 상세 화면에서 다시 돌아왔을 때 기존의 상태값을 유지하도록 하기 위함.
        if reactor == nil {
            reactor = Reactor()
        }
    }
    
    func bind(reactor: SettingReactor) {
        tableView.rx.itemSelected
            .map({ [weak self] indexPath in
                let list = self?.reactor?.settingList ?? []
                
                if 0..<list.count ~= indexPath.row {
                    return Reactor.Action.listSelected(list[indexPath.row].id)
                } else {
                    return Reactor.Action.backButtonSelected
                }
            })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$settingList)
            .bind(onNext: { [weak self] list in
                if list.isEmpty {
                    self?.goNextView()
                } else {
                    self?.updateCells(list.count)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func goNextView() {
        let view = SettingDetailViewController()
        view.parentReactor = reactor
        if let reactor, let id = reactor.currentState.fetchDetailId {
            view.targetId = id
            view.generalInfo = reactor.generalInfo
            view.allListInfo = reactor.allListInfo
        }
        
        navigationController?.pushViewController(view, animated: true)
    }
    
    private func updateCells(_ countForUpdate: Int) {
        tableView.performBatchUpdates { [weak self] in
            
            if let rowCount = self?.tableView.visibleCells.count {
                let deleteTarget = (0..<(rowCount-1)).map { IndexPath(row: $0, section: 0) }
                self?.tableView.deleteRows(at: deleteTarget, with: .left)
            }
            
            let insertTarget = (0..<(countForUpdate)).map { IndexPath(row: $0, section: 0) }
            self?.tableView.insertRows(at: insertTarget, with: .left)
        }
    }
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (reactor?.settingList.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == (reactor?.settingList.count ?? 0) {
            let cell = UITableViewCell()
            var content = cell.defaultContentConfiguration()

            // Configure content.
            content.image = UIImage(systemName: "chevron.left")
            content.text = "Back"

            cell.contentConfiguration = content
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CELL.reuseIdentifier, for: indexPath) as? CELL else {
            return UITableViewCell()
        }
        
        cell.label.text = reactor?.settingList[indexPath.row].title
        
        return cell
    }
}
