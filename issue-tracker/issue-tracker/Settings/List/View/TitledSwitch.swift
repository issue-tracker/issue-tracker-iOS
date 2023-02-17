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
    
    private var disposeBag = DisposeBag()
    
    let label = CommonLabel()
    let trailingSwitch = UISwitch()
    var socialType: SocialType?
    let switchSubject = PublishSubject<(SocialType, Bool)>()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(title: String?, value: Bool = false) {
        self.init(frame: .zero)
        label.text = title
        trailingSwitch.isOn = value
        
        makeUI()
        
        trailingSwitch.rx.controlEvent(.valueChanged)
            .withLatestFrom(trailingSwitch.rx.value)
            .bind { [weak self] value in
                guard let type = self?.socialType else {
                    return
                }
                
                self?.switchSubject.onNext((type, value))
            }
            .disposed(by: disposeBag)
    }
    
    private func makeUI() {
        addSubview(label)
        addSubview(trailingSwitch)
        
        label.snp.contentCompressionResistanceHorizontalPriority = UILayoutPriority.defaultLow.rawValue
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().inset(8)
        }
        
        trailingSwitch.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.trailing).offset(8)
            make.centerY.equalTo(label.snp.centerY)
            make.trailing.equalToSuperview()
        }
    }
}
