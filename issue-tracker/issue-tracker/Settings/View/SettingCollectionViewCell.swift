//
//  SettingCollectionViewCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/11.
//

import UIKit
import SnapKit
import FlexLayout

class SettingCollectionViewCell: UICollectionViewCell {
    
    private let radioButton = UISwitch()
    private let cellImageView = UIImageView()
    private let titleLabel = CommonLabel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeUI()
    }
    
    private func makeUI() {
        contentView.backgroundColor = .systemBackground
        contentView.flex.define { flex in
            flex.addItem(radioButton).margin(4).height(25%)
            flex.addItem().margin(4).grow(1).define { flex in
                flex.addItem(cellImageView).grow(1).marginBottom(4)
                flex.addItem(titleLabel).height(10%)
            }
        }
        
        cellImageView.contentMode = .scaleAspectFit
        contentView.flex.layout()
        contentView.setCornerRadius(8)
        contentView.setShadow(radius: 8)
    }
    
    /// Entity 형태의 구조체를 전달하는 것으로 대체할 예정
    func setState(_ title: String?, image: UIImage?) {
        titleLabel.text = title
        cellImageView.image = image
    }
}
