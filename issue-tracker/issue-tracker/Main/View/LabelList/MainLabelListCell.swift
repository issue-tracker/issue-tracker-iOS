//
//  MainLabelListCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/05.
//

import FlexLayout

final class MainLabelListCell: UITableViewCell, MainListCell {
    private(set) var titleLabel = CommonLabel(fontMultiplier: 1.2)
    private(set) var dateLabel = CommonLabel(fontMultiplier: 0.9)
    private(set) var contentsLabel = CommonLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    func setEntity(_ entity: MainListEntity) {
        titleLabel.text = entity.info.title
        contentsLabel.text = entity.info.contents
        dateLabel.text = entity.info.lastModifiedAt ?? entity.info.createdAt
    }
    
    func makeUI() {
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = UIColor.opaqueSeparator.cgColor
        contentView.setCornerRadius(8)
        contentView.flex.padding(8, 8).direction(.column).define { vStack in
            vStack.addItem(titleLabel)
            vStack.addItem(contentsLabel)
            vStack.addItem(dateLabel)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.flex.layout()
    }
}
