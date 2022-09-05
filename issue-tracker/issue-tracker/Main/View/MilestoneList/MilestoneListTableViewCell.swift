//
//  MilestoneListTableViewCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/05.
//

import FlexLayout
import UIKit

class MilestoneListTableViewCell: MainListTableViewCell<MilestoneListEntity, MilestoneListViewController> {
    private let padding: CGFloat = 8
    
    private var entity: LabelListEntity?
    
    override func makeUI() {
        
        let isBigSizeScreen = ["13","12","11","X"].reduce(false, { $0 || (UIDevice.modelName.contains($1)) })
        contentsLabel.numberOfLines = isBigSizeScreen ? 3 : 2
        
        [titleLabel, dateLabel, contentsLabel].forEach({ label in label.textAlignment = .natural })
        
        contentView.addSubview(paddingView)
        paddingView.addSubview(titleLabel)
        paddingView.addSubview(profileView)
        paddingView.addSubview(dateLabel)
        paddingView.addSubview(contentsLabel)
        
        paddingView.flex.define { flex in
            flex.addItem().direction(.row).height(40%).marginHorizontal(padding).define { flex in
                flex.addItem().width(65%).define { flex in
                    flex.addItem(titleLabel).height(85%)
                    flex.addItem(dateLabel).height(15%)
                }
                flex.addItem(profileView).width(35%).paddingTop(padding).paddingHorizontal(padding).markDirty()
            }
            
            flex.addItem(contentsLabel).vertically(padding).marginHorizontal(padding)
        }
        
        paddingView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(padding)
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

