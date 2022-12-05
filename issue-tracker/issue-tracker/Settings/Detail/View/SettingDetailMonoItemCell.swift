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
            self.valueFieldFlex = flex.addItem(valueField)
        }
        
        contentView.flex.layout()
    }
    
    func setEntity(_ item: any SettingItemValue) {
        
        self.titleLabel.text = item.mainTitle
        
        if let value = item.value as? Bool {
            let switchButton = SettingDetailCellFactory.valueBoolSwitch()
            switchButton.isOn = value
            valueFieldFlex?.addItem(switchButton)
        } else if let value = item.value as? SettingListItemValueColor.SettingValue {
            let colorView = SettingDetailCellFactory.valueColorView()
            colorView.backgroundColor = UIColor(red: CGFloat(value.rgbRed), green: CGFloat(value.rgbGreen), blue: CGFloat(value.rgbBlue), alpha: 0.5)
            valueFieldFlex?.addItem(colorView)
        } else if let value = item.value as? Data, let image = UIImage(data: value) {
            let imageView = SettingDetailCellFactory.valueImageView()
            imageView.image = image
            valueFieldFlex?.addItem(imageView)
        } else if let value = item.value as? String {
            let label = SettingDetailCellFactory.valueStringLabel()
            label.text = value
            label.backgroundColor = UIColor.red.withAlphaComponent(0.5)
            valueFieldFlex?.addItem(label)
        }
        
        contentView.flex.layout()
    }
}
