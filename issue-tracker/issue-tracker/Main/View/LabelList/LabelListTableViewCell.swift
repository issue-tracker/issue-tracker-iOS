//
//  LabelListTableViewCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/05.
//

import FlexLayout

final class LabelListTableViewCell: MainListTableViewCell {
    
    override func makeUI() {
        super.makeUI()
        
        let isBigSizeScreen = ["13","12","11","X"].reduce(false, { $0 || (UIDevice.modelName.contains($1)) })
        let padding: CGFloat = isBigSizeScreen ? 4 : 2
        contentsLabel.numberOfLines = isBigSizeScreen ? 3 : 2
        
        [titleLabel, contentsLabel].forEach({ label in label.textAlignment = .natural })
        dateLabel.textAlignment = .center
        
        contentView.flex.paddingVertical(padding).define { contentsFlex in
            contentsFlex.addItem(paddingView).paddingVertical(padding).define { flex in
                flex.addItem().direction(.row).height(45%).marginHorizontal(padding).define { flex in
                    flex.addItem(titleLabel).width(65%)
                    flex.addItem(dateLabel).width(35%)
                }
                
                flex.addItem(contentsLabel).height(55%).marginHorizontal(padding)
            }
        }
        
        paddingView.setCornerRadius(5)
        paddingView.layer.borderWidth = 1.5
        paddingView.layer.borderColor = UIColor.opaqueSeparator.cgColor
    }
    
    func setEntity(_ entity: LabelListEntity) {
        titleLabel.text = entity.title
        contentsLabel.text = entity.description
        contentsLabel.textColor = entity.textColor.lowercased() == "black" ? .black : .white
        
        dateLabel.text = entity.backgroundColorCode
        setColor(entity.backgroundColorCode)
        
        setNeedsDisplay()
    }
    
    func setColor(_ hexColor: String) {
        let color = UIColor(hex: hexColor)
        dateLabel.textColor = color
        paddingView.backgroundColor = color?.withAlphaComponent(0.5)
    }
}

final class MainLabelListCell: UITableViewCell, MainListCell {
    private(set) var titleLabel = CommonLabel(fontMultiplier: 1.2)
    private(set) var dateLabel = CommonLabel(fontMultiplier: 0.9)
    private(set) var contentsLabel = CommonLabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeUI()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    func setLayout() {
        contentView.flex.layout()
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
