//
//  SettingDetailMultiItemCell+SettingItemLoginActivate.swift
//  issue-tracker
//
//  Created by 백상휘 on 2023/02/23.
//

import UIKit
import RxSwift
import RxCocoa

extension SettingDetailMultiItemCell {
    func setEntity(_ item: SettingItemLoginActivate) {
        item.allCases
            .enumerated().forEach { (index, value) in
                
                let type = SocialType.allCases[index]
                let view = TitledSwitch(title: type.rawValue, value: value)
                
                view.socialType = type
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

