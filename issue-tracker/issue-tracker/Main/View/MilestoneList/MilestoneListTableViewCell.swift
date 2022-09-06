//
//  MilestoneListTableViewCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/05.
//

import FlexLayout
import SnapKit
import UIKit

class MilestoneListTableViewCell: MainListTableViewCell<MilestoneListEntity, MilestoneListViewController> {
    private let padding: CGFloat = 8
    
    private var entity: LabelListEntity?
    
    override func makeUI() {
        
        let isBigSizeScreen = ["13","12","11","X"].reduce(false, { $0 || (UIDevice.modelName.contains($1)) })
        contentsLabel.numberOfLines = isBigSizeScreen ? 2 : 1
        
        [titleLabel, contentsLabel].forEach({ label in label.textAlignment = .natural })
        dateLabel.textAlignment = .center
        
        contentView.addSubview(paddingView)
        paddingView.addSubview(titleLabel)
        paddingView.addSubview(dateLabel)
        paddingView.addSubview(contentsLabel)
        
        paddingView.flex.define { flex in
            flex.addItem().direction(.row).height(40%).marginHorizontal(padding).define { flex in
                flex.addItem(titleLabel).width(55%)
                flex.addItem(dateLabel).width(45%)
            }
            
            flex.addItem(contentsLabel).height(60%).marginHorizontal(padding)
        }
        
        paddingView.snp.makeConstraints { make in
            make.edges.top.equalToSuperview().offset(8)
            make.edges.bottom.equalToSuperview().inset(8)
            make.edges.horizontalEdges.equalToSuperview()
        }
        
        paddingView.layer.borderWidth = 1.5
        paddingView.layer.borderColor = UIColor.opaqueSeparator.cgColor
    }
    
    override func setEntity(_ entity: MilestoneListEntity) {
        titleLabel.text = entity.title
        contentsLabel.text = entity.description
        
        dateLabel.text = "Due by " + DateFormatter.localizedString(from: entity.getDateCreated() ?? Date(), dateStyle: .short, timeStyle: .short)
        setNeedsDisplay()
    }
}

