//
//  TitledSlider.swift
//  issue-tracker
//
//  Created by 백상휘 on 2023/02/22.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class TitledSlider<ValueKey>: UIView {
    
    let slider = UISlider()
    let titleLabel = CommonLabel()
    var valueKey: ValueKey?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    convenience init(title: String, value: Float, valueKey: ValueKey) {
        self.init(frame: .zero)
        self.titleLabel.text = title
        self.slider.value = value
        self.valueKey = valueKey
    }
    
    func makeUI() {
        
        addSubview(titleLabel)
        addSubview(slider)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().inset(8)
        }

        slider.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(8)
        }
    }
}

extension Reactive where Base: TitledSlider<RGBColor> {
    var sliderMoved: ControlEvent<(RGBColor, Float)> {
        return ControlEvent(events: Observable.combineLatest(
            Observable<RGBColor>.create { observer in
                let disposables = Disposables.create()
                if let valueKey = base.valueKey { observer.onNext(valueKey) }
                observer.onCompleted()
                return disposables
            },
            base.slider.rx.value.asObservable()
        ))
    }
}
