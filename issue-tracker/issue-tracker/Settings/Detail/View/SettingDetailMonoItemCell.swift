//
//  SettingDetailMonoItemCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/12/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import CoreData

class SettingDetailMonoItemCell: SettingManagedObjectCell {
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.minimumScaleFactor = 0.2
        return view
    }()
    private let valueSwitch: UISwitch = {
        let view = UISwitch()
        view.isOn = false
        return view
    }()
    
    func makeUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueSwitch)
        
        titleLabel.snp.contentCompressionResistanceHorizontalPriority = UILayoutPriority.defaultLow.rawValue
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().inset(8)
        }
        
        valueSwitch.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(titleLabel.snp.centerY)
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
    }
    
    func setTitle(_ title: String?) {
        titleLabel.text = title
    }
    
    func setEntity(_ value: Bool) {
        valueSwitch.isOn = value
    }
}
