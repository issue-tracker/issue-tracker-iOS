//
//  IssueListTableViewCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/21.
//

import FlexLayout
import UIKit

class IssueListTableViewCell: UITableViewCell {
    
    private let padding: CGFloat = 8
    
    var bindableHandler: ((Any, ViewBinding) -> Void)?
    
    private(set) var titleLabel = CommonLabel(1.3)
    private(set) var profileView = ProfileImageButton()
    private(set) var dateLabel = CommonLabel(0.7)
    private(set) var contentsLabel = CommonLabel(1.1)
    
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
    
    private func defineBindableHandler() {
        bindableHandler = { entity, binding in
            if let entity = entity as? IssueListEntity, binding is IssueListViewController {
                self.setEntity(entity)
            }
        }
    }
    
    private func makeUI() {
        
        let isBigSizeScreen = ["13","12","11","X"].reduce(false, { $0 || (UIDevice.modelName.contains($1)) })
        contentsLabel.numberOfLines = isBigSizeScreen ? 3 : 2
        
        [titleLabel, dateLabel, contentsLabel].forEach({ label in label.textAlignment = .natural })
        
        contentView.addSubview(paddingView)
        paddingView.addSubview(titleLabel)
        paddingView.addSubview(profileView)
        paddingView.addSubview(dateLabel)
        paddingView.addSubview(contentsLabel)
        
        paddingView.flex.define { flex in
            flex.addItem().direction(.row).height(40%).marginHorizontal(padding).define { flex in
                flex.addItem().width(65%).define { flex in
                    flex.addItem(titleLabel).height(85%)
                    flex.addItem(dateLabel).height(15%)
                }
                flex.addItem(profileView).width(35%).paddingTop(padding).paddingHorizontal(padding).markDirty()
            }
            
            flex.addItem(contentsLabel).vertically(padding).marginHorizontal(padding)
        }
        
        paddingView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(padding)
        }
        
        paddingView.layer.borderWidth = 1.5
        paddingView.layer.borderColor = UIColor.opaqueSeparator.cgColor
    }
    
    private func setEntity(_ entity: IssueListEntity) {
        titleLabel.text = entity.title
        dateLabel.text = DateFormatter.localizedString(from: entity.getDateCreated() ?? Date(), dateStyle: .short, timeStyle: .short)
        contentsLabel.text = entity.comments.first?.content
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