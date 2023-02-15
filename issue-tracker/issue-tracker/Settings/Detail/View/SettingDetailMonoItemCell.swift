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
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueSwitch)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().inset(8)
        }
        
        valueSwitch.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(8)
            make.top.equalToSuperview().offset(8)
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
    
    func setEntity(title: String? = nil, _ value: Bool) {
        titleLabel.text = title
        valueSwitch.isOn = value
        
        contentView.setNeedsLayout()
    }
}
