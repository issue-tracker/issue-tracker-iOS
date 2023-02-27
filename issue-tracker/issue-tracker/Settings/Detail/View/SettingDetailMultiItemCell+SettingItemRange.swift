//
//  SettingDetailMultiItemCell+SettingItemRange.swift
//  issue-tracker
//
//  Created by 백상휘 on 2023/02/27.
//

import Foundation
import RxSwift

extension SettingDetailMultiItemCell {
    func setEntity(_ item: SettingItemRange) {
        let range = item.minValue...item.maxValue
        let titles = item.titlesLocalized
        guard range.contains(item.currentValue), range.count <= titles.count else { return }
        
        range.forEach { index in
            let view = TitledSwitch(title: titles[index],
                                    value: index == item.currentValue)
            view.rx.switchTapped
                .map({ type, value in
                    SettingDetailReactor.Action.setLoginActive(type, value)
                })
                .bind { [weak self] in
                    self?.reactor?.action.onNext($0)
                }
                .disposed(by: disposeBag)
            
            
            stackView.addArrangedSubview(view)
        }
    }
}
