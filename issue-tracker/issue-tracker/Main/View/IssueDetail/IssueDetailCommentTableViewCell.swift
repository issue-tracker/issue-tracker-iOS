//
//  IssueDetailCommentTableViewCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/14.
//

import FlexLayout

class IssueDetailCommentTableViewCell: UITableViewCell, IssueDetailCommon, ViewBindable {
    
    private let profileButton: ProfileImageButton = {
        let button = ProfileImageButton()
        button.setCornerRadius(button.frame.width/2)
        return button
    }()
    
    private let authorLabel: CommonLabel = {
        let label = CommonLabel(text: "unknown")
        label.font = .boldSystemFont(ofSize: label.font.pointSize)
        return label
    }()
    
    private let descriptionLabel: CommonLabel = {
        let label = CommonLabel(text: "desc")
        label.textColor = .lightGray
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        return label
    }()
    
    private let infoScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.backgroundColor = .lightGray
        scrollView.setCornerRadius(8)
        return scrollView
    }()
    
    private let textView = UITextView()
    
    private let emojisScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.backgroundColor = .lightGray
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
        contentView.flex.direction(.row).padding(4).define { flex in
            flex.addItem(profileButton).width(20).aspectRatio(1).marginRight(4)
            flex.addItem().grow(1).height(100%).define { flex in
                flex.addItem().width(100%).height(20%).direction(.row).define { flex in
                    flex.addItem(authorLabel).width(25%).marginRight(2)
                    flex.addItem(descriptionLabel).width(20%).marginRight(2)
                    flex.addItem(infoScrollView).grow(1).marginRight(0)
                }
                flex.addItem(textView).width(100%).grow(1)
                flex.addItem(emojisScrollView).width(100%).height(20%)
            }
        }
        
        reloadLayout()
    }
    
    func reloadLayout() {
        contentView.flex.layout()
    }
    
    func setEntity(_ entity: IssueListComment) {
        profileButton.profileImageURL = entity.author.profileImage
        DispatchQueue.main.async { [weak self] in
            guard let scrollView = self?.infoScrollView, let emojis = self?.emojis else { return }
            
            let flex = scrollView.flex
            
            flex.addItem(UIView(frame: CGRect(origin: .zero, size: CGSize(width: 4, height: 0))))
            
            let memberLabel = CommonLabel(text: "member")
            memberLabel.setCornerRadius()
            flex.direction(.row)
                .addItem(memberLabel)
                .aspectRatio(1)
                .height(scrollView.frame.height)
                .marginHorizontal(4)
            
            let authorLabel = CommonLabel(text: "author")
            authorLabel.setCornerRadius()
            flex.direction(.row)
                .addItem(authorLabel)
                .aspectRatio(1)
                .height(scrollView.frame.height)
                .marginHorizontal(4)
            
            for emoji in emojis {
                flex.direction(.row)
                    .addItem(CommonLabel(text: emoji))
                    .aspectRatio(1)
                    .height(scrollView.frame.height)
                    .marginHorizontal(4)
            }
            
            flex.direction(.row)
                .addItem(UIImageView(image: UIImage(systemName: "ellipsis.rectangle")))
                .aspectRatio(1)
                .height(scrollView.frame.height)
                .marginHorizontal(4)
            
            scrollView.flex.addItem(UIView(frame: CGRect(origin: .zero, size: CGSize(width: 4, height: 0))))
            scrollView.reloadContentSizeWidth(rightPadding: 0)
        }
        
        reloadLayout()
    }
    
    private func setEmojis() {
        
    }
}
