//
//  SettingIssueCollectionViewCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/11.
//

import UIKit
import SnapKit
import FlexLayout
import RxSwift
import RxCocoa

class SettingIssueCollectionViewCell: UICollectionViewCell {
    
    private(set) var radioButton = UISwitch()
    private let cellImageView = UIImageView()
    private let titleLabel = CommonLabel()
    
    var index: Int = -1
    
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
    
    private(set) lazy var buttonRXProperty = radioButton.rx.isOn
        .skip(1)
        .map { (self.index, $0) }
    
    private func makeUI() {
        contentView.backgroundColor = .systemBackground
        contentView.layoutIfNeeded()
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
    
    func setEntity(_ entity: SettingItem, at index: Int = -1) {
        guard let entity = entity as? SettingIssueList else {
            return
        }
        
        titleLabel.text = entity.title
        
        if let url = entity.imageURL, let data = try? Data(contentsOf: url) {
            cellImageView.image = UIImage(data: data)
        }
        
        radioButton.setOn(entity.isActivated, animated: true)
        
        self.index = index
    }
}

protocol SettingCollectionViewCell {
    var index: Int { get set }
    func setEntity(_ entity: SettingItem, at index: Int)
}
