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
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.register(SettingDetailMonoItemCell.self, forCellReuseIdentifier: SettingDetailMonoItemCell.reuseIdentifier)
        view.register(SettingDetailMultiItemCell.self, forCellReuseIdentifier: SettingDetailMultiItemCell.reuseIdentifier)
        view.estimatedRowHeight = 80
        
        return view
    }()
    
    /// DetailView의 상태 중 SettingItemValue에 해당하는 값을 List의 Reactor's State로 적용하고 싶을 경우 참조한다.
    var settingItem: SettingListItem?
    var disposeBag: DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        reactor = Reactor(item: settingItem)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.title = "Back"
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
            var label: CommonLabel? {
                cell.contentView.subviews.first(where: {$0 is CommonLabel}) as? CommonLabel
            }
            
            if label == nil {
                let label = CommonLabel(fontMultiplier: 1.2)
                label.textAlignment = .natural
                label.numberOfLines = 0
                cell.contentView.addSubview(label)
                label.snp.makeConstraints { make in
                    make.leading.equalToSuperview().offset(20)
                    make.top.equalToSuperview().offset(8)
                    make.bottom.equalToSuperview().inset(8)
                    make.trailing.equalToSuperview().inset(20)
                }
            }
            
            label?.text = indexPath.row == 0 ? reactor?.currentState.mainTitle : reactor?.currentState.subTitle
            return cell
        }
        
        return SettingTableViewCellFactory.makeCell(in: tableView,
                                                    at: indexPath,
                                                    reactor?.currentState.value)
    }
}
