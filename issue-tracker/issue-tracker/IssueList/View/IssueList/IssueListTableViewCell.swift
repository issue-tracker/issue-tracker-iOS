//
//  IssueListTableViewCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/21.
//

import FlexLayout

class IssueListTableViewCell: UITableViewCell {
    
    private let padding: CGFloat = 8
    
    var bindableHandler: ((Any, ViewBinding) -> Void)?
    
    private(set) var titleLabel = CommonLabel(1.3)
    private(set) var statusLabel = CommonLabel(0.75)
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
        statusLabel.textAlignment = .center
        
        contentView.addSubview(paddingView)
        paddingView.addSubview(titleLabel)
        paddingView.addSubview(statusLabel)
        paddingView.addSubview(dateLabel)
        paddingView.addSubview(contentsLabel)
        
        paddingView.flex.define { flex in
            flex.addItem().direction(.row).height(25%).margin(padding).define { flex in
                flex.addItem(titleLabel).width(65%).marginRight(padding)
                flex.addItem(statusLabel).width(35%)
            }
            flex.addItem(dateLabel).height(15%).marginHorizontal(padding)
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
        
        switch entity.status {
        case .opened:
            statusLabel.text = "열림"
        case .closed:
            statusLabel.text = "닫힘"
        case .standby:
            statusLabel.text = "대기"
        }
        
        dateLabel.text = DateFormatter.localizedString(from: entity.getDateCreated() ?? Date(), dateStyle: .short, timeStyle: .short)
        contentsLabel.text = entity.contents
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
