//
//  IssueDetailCommentTableViewCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/14.
//

import FlexLayout

class IssueDetailCommentTableViewCell: UITableViewCell, IssueDetailCommonType, ViewBindable {
    
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
        label.textColor = .lightGray
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        return label
    }()
    
    private let infoScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        scrollView.setCornerRadius(8)
        return scrollView
    }()
    let memberLabel = CommonLabel(text: "MEMBER")
    let ellipsisImageView = UIImageView(image: UIImage(systemName: "ellipsis.rectangle"))
    
    private let textView = UITextView()
    
    private let emojisScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        scrollView.setCornerRadius()
        return scrollView
    }()
    
    var binding: ViewBinding?
    private var emojis = ["a","b","c","d","a","b","c","d","a","b","c","d"]
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
        ellipsisImageView.tintColor = .lightGray
        
        contentView.flex.direction(.row).padding(UIEdgeInsets(top: 4, left: 8, bottom: 8, right: 8)).define { flex in
            flex.addItem(profileButton).width(20).aspectRatio(1).marginRight(4)
            flex.addItem().grow(1).height(100%).define { flex in
                flex.addItem().direction(.row).width(100%).height(20%).marginBottom(4).define { flex in
                    flex.addItem(authorLabel).width(25%).marginRight(2)
                    flex.addItem(descriptionLabel).grow(1).marginRight(2)
                    flex.addItem(infoScrollView).direction(.row).alignContent(.center).width(30%).marginRight(0).define { flex in
                        flex.addItem(UIView(frame: CGRect(origin: .zero, size: CGSize(width: 4, height: 0))))
                        flex.addItem(memberLabel).aspectRatio(1).height(100%).marginHorizontal(4)
                        flex.addItem(ellipsisImageView).aspectRatio(1).height(100%).marginHorizontal(4)
                        flex.addItem(UIView(frame: CGRect(origin: .zero, size: CGSize(width: 4, height: 0))))
                        infoScrollView.reloadContentSizeWidth()
                    }
                }
                
                flex.addItem(textView).width(100%).grow(1)
                flex.addItem(emojisScrollView).width(100%).height(22%).marginTop(4)
            }
        }
        
        reloadLayout()
    }
    
    private func reloadLayout() {
        DispatchQueue.main.async {
            self.contentView.flex.layout()
        }
    }
    
    func setEntity(_ entity: IssueListComment) {
        profileButton.profileImageURL = entity.author.profileImage
        guard let emojis = self.viewModel?.emojis else {
            return
        }
        
        authorLabel.text = entity.author.nickname
        descriptionLabel.text = entity.createdAt
        
        emojisScrollView.flex.addItem(UIView(frame: CGRect(origin: .zero, size: CGSize(width: 4, height: 0))))
        for emoji in emojis {
            emojisScrollView.flex.alignContent(.center).direction(.row)
                .addItem(CommonLabel(text: emoji))
                .height(emojisScrollView.frame.height)
                .marginHorizontal(4)
        }
        emojisScrollView.flex.addItem(UIView(frame: CGRect(origin: .zero, size: CGSize(width: 4, height: 0))))
        emojisScrollView.reloadContentSizeWidth(rightPadding: 0)
        
        self.reloadLayout()
    }
}
