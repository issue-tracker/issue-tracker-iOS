//
//  CommonTextFieldAreaInputField.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/25.
//

import FlexLayout

class CommonTextFieldAreaInputField: UIView, ViewBinding {
    
    private(set) var textField: CommonTextField?
    private(set) var descriptionLabel: DescriptionLabel? = DescriptionLabel()
    
    private var validationHandler: ((UITextField) -> Bool)?
    private var completionHandler: ((DescriptionLabel, Bool) -> Void)?
    
    var bindableHandler: ((Any?, ViewBindable) -> Void)? = { param, bindable in
        guard
            let param = param as? [String: Any],
            let result = param["result"] as? ResponseStatus
        else {
            return
        }
        
        if let descriptionLabel = bindable as? DescriptionLabel {
            descriptionLabel.popLoading(result.isRequesting)
            descriptionLabel.setResponseStatus(result)
        }
    }
    
    convenience init(_ textField: CommonTextField, willDescribe: Bool = true, validationHandler: ((UITextField) -> Bool)?, completionHandler: ((DescriptionLabel, Bool) -> Void)?) {
        self.init(frame: .zero)
        self.textField = textField
        
        textField.delegate = self
        textField.binding = self
        
        if willDescribe {
            descriptionLabel = DescriptionLabel()
            descriptionLabel?.binding = self
            (textField as? RequestTextField)?.resultLabel = descriptionLabel
        }
        
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
            if let descriptionLabel = descriptionLabel {
                flex.addItem(descriptionLabel).minHeight(20)
            }
        }
        
        flex.layout()
    }
}

extension CommonTextFieldAreaInputField: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let requestTextField = self.textField as? RequestTextField {
            // field를 선언할 때 전달한 validationHandler에서 false가 나오면 completionHandler부터 실행하도록 하였음.
            let result = validationHandler?(textField) ?? true
            
            if result {
                requestTextField.textFieldDidChangeSelection(textField)
            } else if let descriptionLabel = descriptionLabel {
                completionHandler?(descriptionLabel, result)
            }
        }
        
        if let result = validationHandler?(textField), let descriptionLabel = descriptionLabel {
            completionHandler?(descriptionLabel, result)
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        descriptionLabel?.setResponseStatus(ResponseStatus(status: .none, message: "", isRequesting: false))
        return true
    }
}
