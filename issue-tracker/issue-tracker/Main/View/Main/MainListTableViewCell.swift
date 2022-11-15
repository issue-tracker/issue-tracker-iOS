//
//  MainListTableViewCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/05.
//

import UIKit
import FlexLayout

class MainListTableViewCell: UITableViewCell {
    
    var bindableHandler: ((Any, ViewBinding) -> Void)?
    
    private(set) var titleLabel = CommonLabel(fontMultiplier: 1.2)
    private(set) var profileView = ProfileImageButton()
    private(set) var dateLabel = CommonLabel(fontMultiplier: 0.9)
    private(set) var contentsLabel = CommonLabel()
    
    let paddingView = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    /// make UI at first designated initializers.
    func makeUI() {
        paddingView.setCornerRadius(5)
        paddingView.layer.borderWidth = 1.5
        paddingView.layer.borderColor = UIColor.opaqueSeparator.cgColor
    }
    
    func setLayout() {
        contentView.flex.layout()
        setNeedsLayout()
    }
}
