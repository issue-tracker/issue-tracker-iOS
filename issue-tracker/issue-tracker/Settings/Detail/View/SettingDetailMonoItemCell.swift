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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
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
            .map({ SettingDetailReactor.Action.setItemBoolean($0) })
            .subscribe(onNext: { [weak self] in
                self?.reactor?.action.onNext($0)
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
