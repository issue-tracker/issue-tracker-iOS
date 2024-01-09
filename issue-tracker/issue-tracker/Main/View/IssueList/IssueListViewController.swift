//
//  IssueListViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/20.
//

import RxCocoa
import ReactorKit

final class IssueListViewController: MainListViewController<IssueEntity> {
    
    private var bgColor: UIColor?
    
    override func loadView() {
        super.loadView()
        tableView.accessibilityIdentifier = "issueListViewController"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callSetting()
        reactor?.action.onNext(.fetchList)
    }
    
    override func bind(reactor: MainListReactor<IssueEntity>) {
        super.bind(reactor: reactor)
        
        reactor.pulse(\.$list)
            .bind(to: tableView.rx.items(
                cellIdentifier: cellType.reuseIdentifier,
                cellType: cellType)
            ) { inx, entity, cell in
                (cell as? MainListCell)?.setEntity(entity)
            }
            .disposed(by: disposeBag)
    }
}

private extension MainListReactor<IssueEntity> {
    func mutate(action: Action) -> Observable<Mutation> {
        return Observable.never()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        let newState = state
        return newState
    }
}

extension IssueListViewController: SettingProxy {
    func callSetting() {
        let model = MainListCallSettingModel<SettingItemColor>()
        model.settingTitle = "M_ST_SVC_TCELL_CONTENTS_LIST_ISSUE_BGCOLOR".localized

        if let settingItem = model.settingValue {
            bgColor = UIColor(settingItem: settingItem)
        }
    }
}
