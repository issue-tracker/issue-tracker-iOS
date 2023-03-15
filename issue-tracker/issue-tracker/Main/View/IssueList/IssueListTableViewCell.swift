//
//  IssueListTableViewCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/21.
//

import FlexLayout

final class IssueListTableViewCell: MainListTableViewCell {
    
    override func makeUI() {
        super.makeUI()
        
        let isBigSizeScreen = ["13","12","11","X"].reduce(false, { $0 || (UIDevice.modelName.contains($1)) })
        let padding: CGFloat = isBigSizeScreen ? 4 : 2
        contentsLabel.numberOfLines = isBigSizeScreen ? 3 : 2
        
        [titleLabel, dateLabel, contentsLabel].forEach({ label in label.textAlignment = .natural })
        
        contentView.flex.paddingVertical(padding).define { contentsFlex in
            contentsFlex.addItem(paddingView).padding(padding).define { flex in
                flex.addItem().direction(.row).height(50%).marginHorizontal(padding).define { flex in
                    flex.addItem().width(65%).define { flex in
                        flex.addItem(titleLabel).height(75%)
                        flex.addItem(dateLabel).height(25%)
                    }
                    flex.addItem(profileView).width(35%).paddingTop(padding).paddingHorizontal(padding).justifyContent(.center)
                }
                
                flex.addItem(contentsLabel).height(50%).marginHorizontal(padding)
            }
        }
        
        paddingView.setCornerRadius(5)
        paddingView.layer.borderWidth = 1.5
        paddingView.layer.borderColor = UIColor.opaqueSeparator.cgColor
    }
    
    func setEntity(_ entity: IssueListEntity) {
        titleLabel.text = entity.title
        dateLabel.text = DateFormatter.localizedString(from: entity.getDateCreated() ?? Date(), dateStyle: .short, timeStyle: .short)
        contentsLabel.text = entity.comments.first?.content
        
        profileView.profileImageURL = entity.author.profileImage
        setNeedsDisplay()
    }
    
    func setBackgroundColor(_ color: UIColor, setContentsColorContrast: Bool = true) {
        
        paddingView.backgroundColor = color
        
        guard setContentsColorContrast else { return }
        
        let contrastColor = color.contrast
        titleLabel.textColor = contrastColor
        contentsLabel.textColor = contrastColor
        dateLabel.textColor = contrastColor
    }
}

private extension UIColor {
    var contrast: UIColor {
        
        let ciColor = CIColor(color: self)
        
        let compRed: CGFloat = ciColor.red * 0.299
        let compGreen: CGFloat = ciColor.green * 0.587
        let compBlue: CGFloat = ciColor.blue * 0.114
        
        // Counting the perceptive luminance - human eye favors green color...
        let luminance = (compRed + compGreen + compBlue)
        
        // bright colors - black font
        // dark colors - white font
        let col: CGFloat = luminance < 0.55 ? 0 : 1
        
        return UIColor( red: col, green: col, blue: col, alpha: ciColor.alpha)
    }
}
