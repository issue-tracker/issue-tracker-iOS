//
//  IssueDetailTableViewCellSeparator.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/14.
//

import FlexLayout

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
        contentView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        
        contentView.flex.direction(.row).alignContent(.center).paddingHorizontal(4).define { flex in
            flex.addItem(personImageView).height(65%).aspectRatio(1).marginRight(4)
            flex.addItem(profileButton).height(65%).aspectRatio(1).marginRight(4)
            flex.addItem().direction(.row).height(65%).grow(1).define { flex in
                flex.addItem(authorLabel).width(45%).marginRight(2)
                flex.addItem(descriptionLabel).width(55%)
            }
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
        authorLabel.text = entity.author?.nickname
        descriptionLabel.text = entity.contents
    }
}
