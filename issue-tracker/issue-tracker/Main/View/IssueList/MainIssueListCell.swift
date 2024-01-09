//
//  MainIssueListCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/21.
//

import FlexLayout

class MainIssueListCell: UITableViewCell, MainListCell {
    private(set) var titleLabel = CommonLabel(fontMultiplier: 1.2)
    private(set) var profileView = ProfileImageButton(title: "Testing")
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
    
    internal func makeUI() {
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = UIColor.opaqueSeparator.cgColor
        contentView.setCornerRadius(8)
        contentView.flex.direction(.row).padding(8, 8).define { hStack in
            hStack.addItem(profileView).width(20%).aspectRatio(0.8)
            hStack.addItem().direction(.column).define { flex in
                flex.addItem(titleLabel)
                flex.addItem(contentsLabel)
                flex.addItem(dateLabel)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.flex.layout()
    }
    
    func setEntity(_ entity: MainListEntity) {
        titleLabel.text = entity.info.title
        profileView.backgroundColor = .lightGray
        contentsLabel.text = entity.info.contents
        dateLabel.text = entity.info.lastModifiedAt ?? entity.info.createdAt
    }
}
