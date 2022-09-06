//
//  LabelListTableViewCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/05.
//

import FlexLayout
import SnapKit
import UIKit

class LabelListTableViewCell: MainListTableViewCell<LabelListEntity, LabelListViewController> {
    private let padding: CGFloat = 8
    
    private var entity: LabelListEntity?
    
    override func makeUI() {
        
        [titleLabel, contentsLabel].forEach({ label in label.textAlignment = .natural })
        dateLabel.textAlignment = .center
        
        contentView.addSubview(paddingView)
        paddingView.addSubview(titleLabel)
        paddingView.addSubview(dateLabel)
        paddingView.addSubview(contentsLabel)
        
        paddingView.flex.define { flex in
            flex.addItem().direction(.row).height(40%).marginHorizontal(padding).define { flex in
                flex.addItem(titleLabel).width(65%)
                flex.addItem(dateLabel).width(35%)
            }
            
            flex.addItem(contentsLabel).height(60%).marginHorizontal(padding)
        }
        
        paddingView.snp.makeConstraints { make in
            make.edges.top.equalToSuperview().offset(padding)
            make.edges.bottom.equalToSuperview().inset(padding)
            make.edges.horizontalEdges.equalToSuperview()
        }
        
        paddingView.layer.borderWidth = 1.5
        paddingView.layer.borderColor = UIColor.opaqueSeparator.cgColor
    }
    
    override func setEntity(_ entity: LabelListEntity) {
        titleLabel.text = entity.title
        contentsLabel.text = entity.description
        contentsLabel.textColor = entity.textColor.lowercased() == "black" ? .black : .white
        dateLabel.text = entity.backgroundColorCode
        paddingView.backgroundColor = UIColor(hex: entity.backgroundColorCode)
        setNeedsDisplay()
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat((hexNumber & 0x0000ff)) / 255

                    self.init(red: r, green: g, blue: b, alpha: 1)
                    return
                }
            }
        }

        return nil
    }
}
