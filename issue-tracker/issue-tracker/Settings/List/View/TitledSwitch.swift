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
    var socialType: SocialType?
    
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
        trailingSwitch.isOn = value
        
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
    var switchTapped: ControlEvent<(SocialType, Bool)> {
        let source1: Observable<Bool>
        source1 = base.trailingSwitch.rx.value.asObservable()
        
        let source2: Observable<SocialType>
        source2 = Observable.just(base.socialType).compactMap({ $0 })
        
        return ControlEvent(events: Observable.combineLatest(source2, source1))
    }
}
