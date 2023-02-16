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
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .vertical)
        view.minimumScaleFactor = 0.2
        return view
    }()
    
    private let stackView: UIStackView = {
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
        
        label.snp.contentCompressionResistanceHorizontalPriority = UILayoutPriority.defaultLow.rawValue
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().inset(8)
        }
        
        trailingSwitch.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.trailing).offset(8)
            make.centerY.equalTo(label.snp.centerY)
            make.trailing.equalToSuperview()
        }
        
        return view
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.verticalEdges.equalToSuperview()
        }
        
        stackView.addArrangedSubview(titleLabel)
    }
    
    func setTitle(_ title: String?) {
        titleLabel.text = title
    }
    
    func setEntity(_ item: SettingItemColor) {
        let view = UIView()
        view.backgroundColor = UIColor(settingItem: item)
        view.frame.size.height = 80
        
        stackView.addArrangedSubview(view)
    }
    
    func setEntity(_ item: SettingItemLoginActivate) {
        [item.github, item.kakao, item.naver].enumerated()
            .forEach { (index, value) in
                let title = SocialType.allCases[index].rawValue
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
