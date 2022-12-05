//
//  SettingDetailViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/12/02.
//

import UIKit
import SnapKit
import ReactorKit
import RxSwift

class SettingDetailViewController: UIViewController, View {
    typealias Reactor = SettingDetailReactor
    typealias MONOCell = SettingDetailMonoItemCell
    typealias MULTICell = SettingDetailMultiItemCell
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        
        return view
    }()
    
    /// DetailView의 상태 중 SettingItemValue에 해당하는 값을 List의 Reactor's State로 적용하고 싶을 경우 참조한다.
    var parentReactor: SettingReactor?
    
    var settingItemId: UUID?
    
    var targetId: UUID!
    var generalInfo: SettingListItem!
    var allListInfo: SettingListItem!
    
    var disposeBag: DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.register(MONOCell.self, forCellReuseIdentifier: MONOCell.reuseIdentifier)
        tableView.register(MULTICell.self, forCellReuseIdentifier: MULTICell.reuseIdentifier)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reactor = Reactor(targetId: targetId, generalInfo: generalInfo, allListInfo: allListInfo)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func bind(reactor: SettingDetailReactor) {
        reactor.pulse(\.$settingList)
            .bind(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension SettingDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reactor?.settingList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = reactor?.settingList[indexPath.row] else {
            return UITableViewCell()
        }
        
        /// Swift's static typing means the type of a variable must be known at compile time.
        if let itemValue = item.value as? SettingListItemValueList {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MULTICell.reuseIdentifier, for: indexPath) as? MULTICell else { return UITableViewCell() }
            cell.setEntity(itemValue)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MONOCell.reuseIdentifier, for: indexPath) as? MONOCell else { return UITableViewCell() }
            cell.setEntity(item)
            return cell
        }
    }
}
