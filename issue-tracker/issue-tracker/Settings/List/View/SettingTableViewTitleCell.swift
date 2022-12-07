//
//  SettingTableViewTitleCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/12/07.
//

import UIKit
import SnapKit

class SettingTableViewTitleCell: UITableViewCell {
    
    let titleLabel = CommonLabel(fontMultiplier: 1.45)
    
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
        contentView.addSubview(titleLabel)
        
        titleLabel.backgroundColor = .systemBackground
        titleLabel.textAlignment = .left
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
