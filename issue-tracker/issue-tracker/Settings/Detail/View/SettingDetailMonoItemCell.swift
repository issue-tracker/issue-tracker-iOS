//
//  SettingDetailMonoItemCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/12/05.
//

import UIKit
import FlexLayout
import RxSwift
import RxCocoa

class SettingDetailMonoItemCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let valueField: UIView = {
        let view = UIView()
        return view
    }()
    
    private var valueFieldFlex: Flex?
    
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
        titleLabel.backgroundColor = UIColor.opaqueSeparator
        
        contentView.flex.define { flex in
            flex.addItem(titleLabel)
            self.valueFieldFlex = flex.addItem(valueField).width(100%).padding(8)
        }
        
        contentView.flex.layout()
    }
    
    func setEntity(_ value: Bool) {
        titleLabel.text = value ? "True" : "False"
        contentView.flex.layout()
    }
}
