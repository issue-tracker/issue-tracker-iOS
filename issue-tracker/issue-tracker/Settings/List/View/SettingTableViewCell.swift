//
//  SettingsCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/11.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    var index: Int = -1
    let customBackgroundView = UIView()
    let label = CommonLabel(fontMultiplier: 1.45)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeUI()
    }
    
    private func makeUI() {
        contentView.addSubview(customBackgroundView)
        customBackgroundView.addSubview(label)
        
        label.textAlignment = .left
        
        customBackgroundView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(5)
            $0.trailing.bottom.equalToSuperview().inset(5)
            $0.height.equalTo(35)
        }
        
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
