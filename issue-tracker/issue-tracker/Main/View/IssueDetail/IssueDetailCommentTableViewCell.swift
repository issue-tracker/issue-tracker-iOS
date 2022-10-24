//
//  IssueDetailCommentTableViewCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/14.
//

import FlexLayout
import UIKit

class IssueDetailCommentTableViewCell: UITableViewCell, ViewBindable {
    
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
    private let memberLabel: CommonLabel = {
        let label = CommonLabel(text: "Member")
        label.textAlignment = .left
        label.backgroundColor = .opaqueSeparator
        return label
    }()
    
    private let infoScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .opaqueSeparator
        return scrollView
    }()
    
    private let ellipsisImageView: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return button
    }()
    
    private let textView = UITextView()
    
    private let emojisScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.backgroundColor = .opaqueSeparator
        return scrollView
    }()
    
    var binding: ViewBinding?
    
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
        
        contentView.flex.padding(8).define { flex in
            flex.addItem().direction(.row).width(100%).height(50).alignContent(.center).define { flex in
                flex.addItem(profileButton).width(50).aspectRatio(1)
                    .marginRight(4)
                flex.addItem().justifyContent(.spaceEvenly).define { flex in
                    flex.addItem().direction(.row).define { flex in
                        flex.addItem(authorLabel).grow(1)
                        flex.addItem(ellipsisImageView).width(25)
                    }
                    flex.addItem(memberLabel).width(40).height(45%)
                }
                .grow(1)
            }
            flex.addItem(textView).width(100%)
                .grow(1)
            flex.addItem(emojisScrollView).width(100%)
                .height(30)
        }
        
        profileButton.makeCircle()
        memberLabel.setCornerRadius()
        infoScrollView.setCornerRadius()
        emojisScrollView.setCornerRadius()
        contentView.flex.layout()
    }
    
    func setEntity(_ entity: IssueDetailViewModel.Content) {
        profileButton.profileImageURL = entity.profileImage
        
        authorLabel.text = entity.author?.nickname
        textView.text = entity.contents
        
        emojisScrollView.subviews.forEach { $0.removeFromSuperview() }
        emojisScrollView.flex.addItem(UIView(frame: CGRect(origin: .zero, size: CGSize(width: 4, height: 0))))
        
        entity.reactions.forEach { response in
            self.emojisScrollView.flex.alignContent(.center).direction(.row)
                .addItem(CommonLabel(text: response.emoji.convertEmoji()))
                .height(100%)
                .marginRight(4)
        }
        
        emojisScrollView.flex.addItem(UIView(frame: CGRect(origin: .zero, size: CGSize(width: 4, height: 0))))
        emojisScrollView.reloadContentSizeWidth(rightPadding: 0)
        
        contentView.flex.layout()
    }
}
