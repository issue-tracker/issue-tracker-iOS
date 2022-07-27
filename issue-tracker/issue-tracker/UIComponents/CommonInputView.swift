//
//  CommonInputView.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/26.
//

import UIKit
import FlexLayout

enum CommonTextFieldType {
    case normal
    case password
    case email
}

class CommonInputView: UIView {
    
    private var titleLabel = UILabel()
    private var subTitleLabel = UILabel()
    private var titleLabelPosition: InputViewEdges = .top
    private var descriptionLabel = UILabel()
    
    var textField: CommonTextField
    
    convenience init(
        frame: CGRect, input type: UIKeyboardType, placeholder: String?,
        title: String? = nil, subTitle: String? = nil
    ) {
        self.init(frame: frame)
        textField = CommonTextField(frame: frame, input: type, placeholder: placeholder)
        titleLabel.text = title ?? "title"
        subTitleLabel.text = subTitle ?? "subTitle"
    }
    
    override init(frame: CGRect) {
        textField = CommonTextField(frame: frame)
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        textField = CommonTextField(frame: CGRect(origin: .zero, size: .zero))
        super.init(coder: coder)
    }
    
    private func makeUI() {
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(descriptionLabel)
        
        titleLabel.frame.size.height = 16
        subTitleLabel.frame.size.height = 16
        descriptionLabel.frame.size.height = 16
        
        self.flex.define { flex in
            if titleLabelPosition == .top {
                flex.addItem(titleLabel)
                flex.addItem(subTitleLabel)
                flex.addItem(textField)
            } else {
                flex.addItem().direction(.row).define { flex in
                    if titleLabelPosition == .leading {
                        flex.addItem().define { flex in
                            flex.addItem(subTitleLabel)
                            flex.addItem(titleLabel)
                        }.width(30%)
                        flex.addItem(textField).grow(1)
                    } else {
                        flex.addItem(textField).grow(1)
                        flex.addItem().define { flex in
                            flex.addItem(subTitleLabel)
                            flex.addItem(titleLabel)
                        }.width(30%)
                    }
                }
            }
            
            flex.addItem(descriptionLabel)
        }
        
        layoutIfNeeded()
    }
    
    func setTitle(_ title: String, position: InputViewEdges = .top) {
        titleLabelPosition = position
        titleLabel.text = title
        layoutIfNeeded()
    }
    
    func setDescription(_ title: String) {
        descriptionLabel.text = title
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: frame.width, height: frame.height))
        }
        
        self.flex.layout()
    }
}

enum InputViewEdges {
    case top
    case leading
    case trailing
}
