//
//  LabelListViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/29.
//

import RxCocoa
import ReactorKit

final class LabelListViewController: MainListViewController<LabelEntity> {
    
    private var bgColor: UIColor?
    
    override func loadView() {
        super.loadView()
        tableView.accessibilityIdentifier = "labelListViewController"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callSetting()
        reactor?.action.onNext(.fetchList)
    }
    
    override func bind(reactor: MainListReactor<LabelEntity>) {
        super.bind(reactor: reactor)
        
        reactor.pulse(\.$list)
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(
                cellIdentifier: cellType.reuseIdentifier,
                cellType: cellType)
            ) { index, entity, cell in
                (cell as? MainListCell)?.setEntity(entity)
            }
            .disposed(by: disposeBag)
    }
}

private extension MainListReactor<LabelEntity> {
    func mutate(action: Action) -> Observable<Mutation> {
        return Observable.never()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        let newState = state
        return newState
    }
}

extension LabelListViewController: SettingProxy {
    func callSetting() {
        let model = MainListCallSettingModel<SettingItemColor>()
        model.settingTitle = "M_ST_SVC_TCELL_CONTENTS_LIST_LABEL_BGCOLOR".localized
        if let settingItem = model.settingValue {
            bgColor = UIColor(settingItem: settingItem)
        }
    }
}
