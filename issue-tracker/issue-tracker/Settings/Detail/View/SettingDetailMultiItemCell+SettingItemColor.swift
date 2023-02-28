//
//  SettingDetailMultiItemCell+SettingItemColor.swift
//  issue-tracker
//
//  Created by 백상휘 on 2023/02/23.
//

import UIKit
import RxSwift
import RxCocoa

extension SettingDetailMultiItemCell {
    func setEntity(_ item: SettingItemColor) {
        [
            (RGBColor.red, item.rgbRed, UIColor.red),
            (RGBColor.blue, item.rgbBlue, UIColor.blue),
            (RGBColor.green, item.rgbGreen, UIColor.green)
        ]
            .forEach { type, value, uiColor in
                
                let titleSlider = TitledSlider<RGBColor>(title: type.rawValue, value: value/255.0, valueKey: type)
                titleSlider.slider.minimumTrackTintColor = uiColor
                titleSlider.slider.maximumTrackTintColor = uiColor
                titleSlider.rx.sliderMoved
                    .observe(on: MainScheduler.asyncInstance)
                    .do(onNext: { [weak self] type, value in
                        let targetView = self?.stackView.arrangedSubviews.last as? UIView
                        guard let color = targetView?.backgroundColor else {
                            return
                        }
                        
                        switch type {
                        case .red:
                            targetView?.backgroundColor = UIColor(red: CGFloat(value), green: color.components.green, blue: color.components.blue, alpha: 1)
                        case .blue:
                            targetView?.backgroundColor = UIColor(red: color.components.red, green: color.components.green, blue: CGFloat(value), alpha: 1)
                        case .green:
                            targetView?.backgroundColor = UIColor(red: color.components.red, green: CGFloat(value), blue: color.components.blue, alpha: 1)
                        }
                    })
                    .map({ type, value in SettingDetailReactor.Action.setColorSetting(type, value * 255) })
                    .bind { [weak self] in self?.reactor?.action.onNext($0) }
                    .disposed(by: disposeBag)
                
                stackView.addArrangedSubview(titleSlider)
            }
        
        let view = UIView()
        view.backgroundColor = UIColor(settingItem: item)
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        stackView.addArrangedSubview(view)
    }
}

private extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    
    //UIColor에서 rgb값 뽑아내기
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let color = coreImageColor
        return (color.red, color.green, color.blue, color.alpha)
    }
}
