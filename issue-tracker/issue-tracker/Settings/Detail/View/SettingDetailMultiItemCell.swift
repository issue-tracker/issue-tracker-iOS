//
//  SettingDetailMultiItemCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/12/05.
//

import UIKit
import RxSwift
import RxCocoa
import FlexLayout
import CoreData

class SettingDetailMultiItemCell: SettingManagedObjectCell {
    
    let titledSwitch: (String, Bool) -> UIView = { title, value in
        let view = UIView()
        let label = UILabel()
        let trailingSwitch = UISwitch()
        
        label.text = title
        trailingSwitch.isOn = value
        
        view.frame.size.height = 80
        view.flex.direction(.row).define { flex in
            flex.addItem(label).width(45%).padding(8)
            flex.addItem(trailingSwitch).padding(8)
        }
        view.flex.layout(mode: .adjustHeight)
        
        return view
    }
    
    func setEntity(_ item: ColorSets) {
        contentView.backgroundColor = UIColor(
            red: CGFloat(item.rgbRed) / 255,
            green: CGFloat(item.rgbGreen) / 255,
            blue: CGFloat(item.rgbBlue) / 255,
            alpha: 1
        )
    }
    
    func setEntity(_ item: LoginActivate) {
        contentView.removeFromSuperview()
        let switches = [item.github, item.kakao, item.naver]
            .enumerated()
            .map { (index, value) in
                var title: String {
                    if index == 0 {
                        return "github"
                    } else if index == 1 {
                        return "kakao"
                    } else {
                        return "naver"
                    }
                }
                
                return self.titledSwitch(title, value)
            }
        
        let contentFlex = contentView.flex.define { _ in }
        
        for (index, switchView) in switches.enumerated() {
            contentFlex.addItem(switchView).width(100%)
            
            if let switchButton = switchView.subviews.first(where: {$0 is UISwitch}) as? UISwitch {
                switchButton.rx
                    .controlEvent(.valueChanged)
                    .withLatestFrom(switchButton.rx.value)
                    .subscribe(onNext: { [weak self] isOn in
                        guard
                            var value = self?.managedObject?.value as? LoginActivate,
                            let context = NSManagedObjectContext.viewContext
                        else {
                            return
                        }
                        
                        do {
                            switch index {
                            case 0: value.github = isOn
                            case 1: value.kakao = isOn
                            case 2: value.naver = isOn
                            default: return
                            }
                            
                            self?.managedObject?.value = value
                            try context.save()
                        } catch {
                            print(error)
                        }
                    })
                    .disposed(by: disposeBag)
            }
        }
        
        contentFlex.layout(mode: .adjustHeight)
    }
}
