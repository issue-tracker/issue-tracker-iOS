//
//  LabelListTableViewCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/05.
//

import FlexLayout
import SnapKit
import UIKit

class LabelListTableViewCell: MainListTableViewCell<LabelListEntity> {
    private let padding: CGFloat = 8
    
    private var entity: LabelListEntity?
    
    override func makeUI() {
        
        [titleLabel, contentsLabel].forEach({ label in label.textAlignment = .natural })
        dateLabel.textAlignment = .center
        
        contentView.addSubview(paddingView)
        paddingView.addSubview(titleLabel)
        paddingView.addSubview(dateLabel)
        paddingView.addSubview(contentsLabel)
        
        paddingView.flex.define { flex in
            flex.addItem().direction(.row).height(45%).marginHorizontal(padding).define { flex in
                flex.addItem(titleLabel).width(65%)
                flex.addItem(dateLabel).width(35%)
            }
            
            flex.addItem(contentsLabel).height(55%).marginHorizontal(padding)
        }
        
        paddingView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(padding)
            make.bottom.equalToSuperview().inset(padding)
            make.horizontalEdges.equalToSuperview()
        }
        
        paddingView.layer.borderWidth = 1.5
        paddingView.layer.borderColor = UIColor.opaqueSeparator.cgColor
    }
    
    override func setEntity(_ entity: LabelListEntity) {
        titleLabel.text = entity.title
        contentsLabel.text = entity.description
        contentsLabel.textColor = entity.textColor.lowercased() == "black" ? .black : .white
        
        let color = UIColor(hex: entity.backgroundColorCode)
        dateLabel.text = entity.backgroundColorCode
        dateLabel.textColor = color
        paddingView.backgroundColor = color?.withAlphaComponent(0.5)
        setNeedsDisplay()
    }
}
