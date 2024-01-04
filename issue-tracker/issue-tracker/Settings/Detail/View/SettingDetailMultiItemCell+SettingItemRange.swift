//
//  SettingDetailMultiItemCell+SettingItemRange.swift
//  issue-tracker
//
//  Created by 백상휘 on 2023/02/27.
//

import Foundation
import RxSwift
import RxCocoa

extension SettingDetailMultiItemCell {
    func setEntity(_ item: SettingItemRange) {
        let range = item.minValue...item.maxValue
        let titles = item.titlesLocalized
        guard range.contains(item.currentValue), range.count <= titles.count else { return }
        
        var switches: [UISwitch] = []
        range.forEach { index in
            let view = TitledSwitch(title: titles[index],
                                    value: index == item.currentValue)
            
            switches.append(view.trailingSwitch)
            
            view.trailingSwitch.rx.value
                .map({ _ in SettingDetailReactor.Action.setRange(index) })
                .bind { [weak self] in self?.reactor?.action.onNext($0) }
                .disposed(by: disposeBag)
            
            stackView.addArrangedSubview(view)
        }
        
        for (i, singleSwitch) in switches.enumerated() {
            singleSwitch.rx.isOn
                .skip(1).map({ _ in i })
                .observe(on: MainScheduler.instance)
                .bind(onNext: { [weak self] i in
                    self?.allSwitches.enumerated().forEach({ index, target in
                        if i != index {
                            target.isOn = false
                        }
                    })
                })
                .disposed(by: disposeBag)
        }
    }
    
    var allSwitches: [UISwitch] {
        let result = stackView.arrangedSubviews
            .compactMap({$0.subviews.first(where: { $0 is UISwitch })})
        return (result as? [UISwitch]) ?? []
    }
}
