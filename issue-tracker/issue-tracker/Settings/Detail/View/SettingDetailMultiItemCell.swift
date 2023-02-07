//
//  SettingDetailMultiItemCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/12/05.
//

import UIKit

class SettingDetailMultiItemCell: UITableViewCell {
    
    let tempView: UIView = {
        let view = UIView()
        return view
    }()
    
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
        contentView.addSubview(tempView)
        tempView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setEntity(_ item: ColorSets) {
        tempView.backgroundColor = UIColor(
            red: CGFloat(item.rgbRed) / 255,
            green: CGFloat(item.rgbGreen) / 255,
            blue: CGFloat(item.rgbBlue) / 255,
            alpha: 1
        )
    }
}
