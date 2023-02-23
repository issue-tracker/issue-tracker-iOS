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

class TitledSlider: UIView {
    
    let slider = UISlider()
    let titleLabel = CommonLabel()
    var colorType: RGBColor = .red
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    convenience init(title: String, value: Float, colorType: RGBColor) {
        self.init(frame: .zero)
        self.titleLabel.text = title
        self.slider.value = value
        self.colorType = colorType
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

extension Reactive where Base: TitledSlider {
    var sliderMoved: ControlEvent<(RGBColor, Float)> {
        let source1 = Observable.just(base.colorType)
        let source2 = base.slider.rx.value.asObservable()
        return ControlEvent(events: Observable.combineLatest(source1, source2))
    }
}
