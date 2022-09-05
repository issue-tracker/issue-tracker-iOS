//
//  MainListTableViewCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/05.
//

import UIKit

class MainListTableViewCell<T: Codable, VC: ViewBinding>: UITableViewCell {
    
    var bindableHandler: ((Any, ViewBinding) -> Void)?
    
    private(set) var titleLabel = CommonLabel(fontMultiplier: 1.3)
    private(set) var profileView = ProfileImageButton()
    private(set) var dateLabel = CommonLabel(fontMultiplier: 0.7)
    private(set) var contentsLabel = CommonLabel(fontMultiplier: 1.1)
    
    let paddingView = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetting()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetting()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialSetting()
    }
    
    private func initialSetting() {
        makeUI()
        defineBindableHandler()
    }
    
    func makeUI() { }
    func setEntity(_ entity: T) { }
    
    private func defineBindableHandler() {
        bindableHandler = { entity, binding in
            if let entity = entity as? T, binding is VC {
                self.setEntity(entity)
            }
        }
    }
    
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
