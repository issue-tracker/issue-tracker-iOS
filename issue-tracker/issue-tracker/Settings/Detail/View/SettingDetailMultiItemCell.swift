//
//  SettingDetailMultiItemCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/12/05.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import CoreData

class SettingDetailMultiItemCell: SettingManagedObjectCell {
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    let titledSwitch: (String, Bool) -> UIView = { title, value in
        let view = UIView()
        let label = UILabel()
        let trailingSwitch = UISwitch()
        
        label.text = title
        trailingSwitch.isOn = value
        
        view.addSubview(label)
        view.addSubview(trailingSwitch)
        
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().inset(8)
        }
        
        trailingSwitch.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(8)
            make.top.equalToSuperview().offset(8)
        }
        
        return view
    }
    
    func setEntity(_ item: SettingItemColor) {
        contentView.backgroundColor = UIColor(
            red: CGFloat(item.rgbRed) / 255,
            green: CGFloat(item.rgbGreen) / 255,
            blue: CGFloat(item.rgbBlue) / 255,
            alpha: 1
        )
    }
    
    func setEntity(_ item: SettingItemLoginActivate) {
        contentView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [item.github, item.kakao, item.naver].enumerated()
            .forEach { (index, value) in
                var title: String {
                    if index == 0 {
                        return "github"
                    } else if index == 1 {
                        return "kakao"
                    } else {
                        return "naver"
                    }
                }
                
                let view = self.titledSwitch(title, value)
                
                if let switchView = view.subviews.first(where: {$0 is UISwitch}) as? UISwitch {
                    switchView.rx.controlEvent(.valueChanged)
                        .withLatestFrom(switchView.rx.value)
                        .map({(index, $0)})
                        .subscribe(onNext: { [weak self] index, isOn in
                            guard
                                let managedObject = self?.managedObject,
                                let value = managedObject.value as? SettingItemLoginActivate
                            else {
                                return
                            }
                            
                            do {
                                switch index {
                                case 0: value.github = isOn
                                case 1: value.kakao = isOn
                                default: value.naver = isOn
                                }
                                
                                managedObject.setValue(value, forKeyPath: #keyPath(SettingListItem.value))
                                try NSManagedObjectContext.viewContext?.save()
                            } catch {
                                print(error)
                            }
                        })
                        .disposed(by: disposeBag)
                }
                
                stackView.addArrangedSubview(view)
            }
    }
}
