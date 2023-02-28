//
//  TitledSwitch.swift
//  issue-tracker
//
//  Created by 백상휘 on 2023/02/17.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class TitledSwitch: UIView {
    let label = CommonLabel()
    let trailingSwitch = UISwitch()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(title: String?, value: Bool = false) {
        self.init(frame: .zero)
        label.text = title
        label.textAlignment = .natural
        trailingSwitch.setOn(value, animated: true)
        
        makeUI()
    }
    
    private func makeUI() {
        addSubview(label)
        addSubview(trailingSwitch)
        
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().inset(8)
        }
        
        trailingSwitch.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.trailing).offset(8)
            make.centerY.equalTo(label.snp.centerY)
            make.trailing.equalToSuperview().inset(8)
        }
    }
}

extension Reactive where Base: TitledSwitch {
    func switchTapped<T>(with t: T) -> ControlEvent<(T, Bool)> {
        return ControlEvent(events: Observable.combineLatest(
            Observable.just(t),
            base.trailingSwitch.rx.value.asObservable()
        ))
    }
}
