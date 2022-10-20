//
//  SettingIssueQueryViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/07.
//

import SnapKit
import RxSwift
import RxCocoa
import Foundation


/// UITableView EditMode 이용해서 적용할 쿼리와 적용하지 않을 쿼리를 설정할 수 있도록 함.
///
/// 삭제 추가가 가능하게 해야할지는 잘 모르겠음.
class SettingIssueQueryViewController: UIViewController {
    private let padding: CGFloat = 8
    
    private let tableView = UITableView()
    private var disposeBag = DisposeBag()
    
    private let model = SettingIssueQueryModel.init(key: IssueSettings.query)
    
    let addQuerySubject = PublishRelay<SettingIssueQueryItem>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Query"
        view.addSubview(tableView)
        
        tableView.rowHeight = 50
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        typealias CELL = SettingIssueQueryCell
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: UIAction(handler: { [weak self] _ in
            self?.present(SettingQueryInsertView(self?.addQuerySubject), animated: true)
        }))
        
        addQuerySubject
            .subscribe(onNext: { [weak self] entity in
                self?.model.addEntity(entity)
            })
            .disposed(by: disposeBag)
        
        tableView.register(CELL.self, forCellReuseIdentifier: CELL.reuseIdentifier)
        tableView.delegate = self
        tableView.setEditing(true, animated: false)
        tableView.rx.itemMoved
            .bind(onNext: { [weak self] info in
                self?.model.swapEntities(from: info.sourceIndex.row, to: info.destinationIndex.row)
            })
            .disposed(by: disposeBag)
        model.entitiesRelay
            .bind(to: tableView.rx.items(cellIdentifier: CELL.reuseIdentifier, cellType: CELL.self)) { _, entity, cell in
                cell.setEntity(entity)
            }
            .disposed(by: disposeBag)
    }
}

extension SettingIssueQueryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
}
