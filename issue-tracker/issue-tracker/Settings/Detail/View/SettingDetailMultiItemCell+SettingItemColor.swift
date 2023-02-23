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
            (RGBColor.red, item.rgbRed, UIColor(red: CGFloat(item.rgbRed/255), green: 0, blue: 0, alpha: 1)),
            (RGBColor.blue, item.rgbBlue, UIColor(red: 0, green: 0, blue: CGFloat(item.rgbBlue/255), alpha: 1)),
            (RGBColor.green, item.rgbGreen, UIColor(red: 0, green: CGFloat(item.rgbGreen/255), blue: 0, alpha: 1))
        ]
            .forEach { type, value, uiColor in
                
                let titleSlider = TitledSlider(title: type.rawValue, value: value, colorType: type)
                titleSlider.slider.maximumTrackTintColor = uiColor
                titleSlider.slider.minimumTrackTintColor = uiColor
                titleSlider.rx.sliderMoved
                    .map({ colorType, value in
                        SettingDetailReactor.Action.setColorSetting(colorType, value)
                    })
                    .bind { [weak self] in
                        self?.reactor?.action.onNext($0)
                    }
                    .disposed(by: disposeBag)
                
                stackView.addArrangedSubview(titleSlider)
            }
        
        let view = UIView()
        view.backgroundColor = UIColor(settingItem: item)
        view.frame.size.height = 80
        
        stackView.addArrangedSubview(view)
    }
}
