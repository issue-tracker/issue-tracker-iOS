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
    
    let titleLabel: CommonLabel = {
        let view = CommonLabel()
        view.numberOfLines = 0
        view.textAlignment = .natural
        return view
    }()
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
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
        item.allCases.enumerated().forEach { (index, value) in
            let type = SocialType.allCases[index]
            let view = TitledSwitch(title: type.rawValue, value: value)
            
            view.socialType = type
            view.switchSubject.bind { [weak self] type, value in
                
                let loginSetting = self?.managedObject?.value as? SettingItemLoginActivate
                switch type {
                case .github:
                    loginSetting?.github = value
                case .naver:
                    loginSetting?.naver = value
                case .kakao:
                    loginSetting?.kakao = value
                }
                
                do {
                    self?.managedObject?.setValue(loginSetting,
                                                  forKeyPath: #keyPath(SettingListItem.value))
                    try NSManagedObjectContext.viewContext?.save()
                } catch {
                    print(error)
                }
            }
            .disposed(by: disposeBag)
            
            stackView.addArrangedSubview(view)
        }
    }
}
