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
    var settingItem: SettingListItem?
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
        reactor = Reactor(item: settingItem)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func bind(reactor: SettingDetailReactor) {
        reactor.pulse(\.$value)
            .bind(onNext: { [weak tableView] value in
                tableView?.performBatchUpdates({
                    tableView?.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .fade)
                })
            })
            .disposed(by: disposeBag)
    }
}

extension SettingDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row > 1 else {
            let cell = UITableViewCell()
            cell.textLabel?.text = indexPath.row == 0 ? reactor?.currentState.mainTitle : reactor?.currentState.subTitle
            return cell
        }
        
        if let itemValue = reactor?.currentState.value as? ColorSets {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MULTICell.reuseIdentifier, for: indexPath) as? MULTICell else { return UITableViewCell() }
            
            cell.setEntity(itemValue)
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MONOCell.reuseIdentifier, for: indexPath) as? MONOCell else { return UITableViewCell() }
            var result = false
            
            if let value = reactor?.currentState.value {
                let cfValue = value as! CFBoolean
                result = cfValue == kCFBooleanTrue
            }
            
            cell.setEntity(result)
            
            return cell
        }
    }
}
