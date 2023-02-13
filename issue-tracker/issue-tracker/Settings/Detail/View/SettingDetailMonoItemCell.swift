//
//  SettingDetailMonoItemCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/12/05.
//

import UIKit
import FlexLayout
import RxSwift
import RxCocoa
import CoreData

class SettingDetailMonoItemCell: SettingManagedObjectCell {
    let titleLabel: UILabel = {
        let view = UILabel()
        view.minimumScaleFactor = 0.2
        return view
    }()
    let valueSwitch: UISwitch = {
        let view = UISwitch()
        view.isOn = false
        return view
    }()
    
    func makeUI() {
        contentView.flex
            .justifyContent(.end)
            .direction(.row)
            .define { flex in
                flex.addItem(titleLabel).grow(1).padding(8)
                flex.addItem(valueSwitch).padding(8)
            }
        
        valueSwitch.rx
            .controlEvent(.valueChanged)
            .withLatestFrom(valueSwitch.rx.value)
            .subscribe(onNext: { [weak self] isOn in
                guard
                    let managedObject = self?.managedObject,
                    let valueMutating = cfCast(isOn, to: CFBoolean.self)
                else {
                    return
                }
                
                do {
                    managedObject.value = valueMutating
                    try NSManagedObjectContext.viewContext?.save()
                } catch {
                    print(error)
                }
            })
            .disposed(by: disposeBag)
        
        contentView.flex.layout(mode: .adjustHeight)
    }
    
    func setEntity(title: String? = nil, _ value: Bool) {
        titleLabel.text = title
        valueSwitch.isOn = value
        
        contentView.setNeedsLayout()
    }
}
