//
//  MainListTableViewCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/05.
//

import UIKit
import FlexLayout

class MainListTableViewCell<T: Codable, VC: ViewBinding>: UITableViewCell {
    
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
    
    func makeUI() { }
    func setEntity(_ entity: T) { }
    
    func setLayout() {
        paddingView.layoutIfNeeded()
        paddingView.flex.layout()
        paddingView.setCornerRadius(5)
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
