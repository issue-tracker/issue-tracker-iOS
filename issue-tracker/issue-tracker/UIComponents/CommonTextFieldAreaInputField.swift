//
//  CommonTextFieldAreaInputField.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/25.
//

import FlexLayout

class CommonTextFieldAreaInputField: UIView {
    
    private(set) var textField: CommonTextField?
    private(set) var descriptionLabel = DescriptionLabel()
    
    private var validationHandler: ((UITextField) -> Bool)?
    private var completionHandler: ((DescriptionLabel, Bool) -> Void)?
    
    convenience init(_ textField: CommonTextField, validationHandler: @escaping (UITextField) -> Bool, completionHandler: @escaping (DescriptionLabel, Bool) -> Void) {
        self.init(frame: .zero)
        self.textField = textField
        self.validationHandler = validationHandler
        self.completionHandler = completionHandler
        makeUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func makeUI() {
        
        guard let textField = textField else {
            return
        }
        
        flex.define { flex in
            flex.addItem(textField).minHeight(40).marginBottom(8)
            flex.addItem(descriptionLabel).minHeight(20)
        }
        
        flex.layout()
    }
}

extension CommonTextFieldAreaInputField: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let result = validationHandler?(textField) {
            completionHandler?(descriptionLabel, result)
        }
    }
}
