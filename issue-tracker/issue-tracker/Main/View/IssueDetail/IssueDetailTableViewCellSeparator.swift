//
//  IssueDetailTableViewCellSeparator.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/14.
//

import FlexLayout
import Foundation

class IssueDetailTableViewCellSeparator: UITableViewCell, ViewBindable {
    
    private let personImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.circle"))
        imageView.setCornerRadius(imageView.frame.width/2)
        return imageView
    }()
    
    private let profileButton: ProfileImageButton = {
        let button = ProfileImageButton()
        button.setCornerRadius(button.frame.width/2)
        return button
    }()
    
    private let authorLabel: CommonLabel = {
        let label = CommonLabel(text: "unknown")
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: label.font.pointSize)
        return label
    }()
    
    private let descriptionLabel: CommonLabel = {
        let label = CommonLabel(text: "desc")
        label.textAlignment = .left
        label.textColor = .lightGray
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        return label
    }()
    
    var binding: ViewBinding?
    private var viewModel: IssueDetailViewModel? {
        (binding as? IssueDetailViewController)?.model
    }

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
    
    private func makeUI() {
        contentView.backgroundColor = nil
        contentView.flex.direction(.row).alignContent(.center).paddingHorizontal(4).define { flex in
            flex.addItem(personImageView).aspectRatio(1).marginRight(4)
            flex.addItem(descriptionLabel).grow(1)
        }
        
        reloadLayout()
    }
    
    private func reloadLayout() {
        DispatchQueue.main.async {
            self.contentView.flex.layout()
        }
    }
    
    func setEntity(_ entity: IssueDetailViewModel.Content) {
        profileButton.profileImageURL = entity.profileImage
        let str = NSMutableAttributedString(string: (entity.author?.nickname ?? "") + entity.contents)
        str.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: descriptionLabel.font.pointSize), range: NSRange(location: 0, length: (entity.author?.nickname ?? "").count))
        descriptionLabel.text = str.string
    }
}
