//
//  IssueListTableViewCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/21.
//

import FlexLayout
import SnapKit
import UIKit

class IssueListTableViewCell: MainListTableViewCell<IssueListEntity, IssueListViewController> {
    private let padding: CGFloat = 8
    
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
            flex.addItem().direction(.row).height(50%).marginHorizontal(padding).define { flex in
                flex.addItem().width(65%).define { flex in
                    flex.addItem(titleLabel).height(85%)
                    flex.addItem(dateLabel).height(15%)
                }
                flex.addItem(profileView).width(35%).paddingTop(padding).paddingHorizontal(padding).justifyContent(.center).markDirty()
            }
            
            flex.addItem(contentsLabel).vertically(padding).marginHorizontal(padding)
        }
        
        paddingView.snp.makeConstraints { make in
            make.edges.top.equalToSuperview().offset(padding)
            make.edges.bottom.equalToSuperview().inset(padding)
            make.edges.horizontalEdges.equalToSuperview()
        }
        
        paddingView.layer.borderWidth = 1.5
        paddingView.layer.borderColor = UIColor.opaqueSeparator.cgColor
    }
    
    override func setEntity(_ entity: IssueListEntity) {
        titleLabel.text = entity.title
        dateLabel.text = DateFormatter.localizedString(from: entity.getDateCreated() ?? Date(), dateStyle: .short, timeStyle: .short)
        contentsLabel.text = entity.comments.first?.content
        
        profileView.profileImageURL = entity.author.profileImage
    }
}
