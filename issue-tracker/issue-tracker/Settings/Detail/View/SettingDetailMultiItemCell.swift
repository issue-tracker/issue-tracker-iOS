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
    
    let stackView: UIStackView = {
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
}
