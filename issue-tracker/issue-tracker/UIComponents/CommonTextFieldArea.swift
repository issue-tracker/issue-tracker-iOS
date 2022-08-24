//
//  CommonTextFieldArea.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/24.
//

import FlexLayout

class CommonTextFieldArea: UIView, ViewBinding {
    private let padding: CGFloat = 8
    private var key: String = ""
    private var completionHandler: (()->Void)?
    
    private(set) var textField: CommonTextField?
    var descriptionLabel: DescriptionLabel? {
        (textField as? RequestTextField)?.resultLabel as? DescriptionLabel
    }
    var bindableHandler: ((Any?, ViewBindable) -> Void)? = { param, bindable in
        guard let param = param as? [String: Any] else { return }
        
        if let descriptionLabel = bindable as? DescriptionLabel, let result = param["result"] as? ResponseStatus {
            
            descriptionLabel.popLoading(result.isRequesting)
            descriptionLabel.setResponseStatus(result)
        }
    }
    
    convenience init(key: String) {
        self.init()
        self.key = key
    }
    
    convenience init(
        @CommonTextFieldAreaBuilder _ content: () -> CommonTextFieldComponents?,
        _ completionHandler: (()->Void)? = nil
    ) {
        self.init()
        self.completionHandler = completionHandler
        
        guard let component = content() else { return }
        
        let titleLabel = UILabel()
        titleLabel.attributedText = NSAttributedString(
            string: component.title,
            attributes: [.font: UIFont.preferredFont(forTextStyle: .headline, compatibleWith: nil)]
        )
        
        let subTitleLabel = UILabel()
        subTitleLabel.attributedText = NSAttributedString(
            string: component.subTitle ?? "",
            attributes: [.font: UIFont.italicSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .subheadline).pointSize)]
        )
        subTitleLabel.adjustsFontSizeToFitWidth = true
        
        var commonTextField: CommonTextField!
        if let url = component.url {
            let requestTextfield = RequestTextField(frame: .zero, input: .default, placeholder: component.placeHolderString, markerType: .none)
            requestTextfield.requestURL = url
            requestTextfield.optionalTrailingPath = component.optionalTrailingPath
            requestTextfield.validateStringCount = component.validateStringCount
            commonTextField = requestTextfield
        } else {
            commonTextField = CommonTextField(frame: .zero, input: .default, placeholder: component.placeHolderString)
        }
        
        commonTextField.delegate = commonTextField
        commonTextField.binding = self
        
        let descriptionLabel = DescriptionLabel()
        descriptionLabel.binding = self
        descriptionLabel.attributedText = NSAttributedString(
            string: component.description ?? "",
            attributes: [.font: UIFont.preferredFont(forTextStyle: .footnote)]
        )
        
        (commonTextField as? RequestTextField)?.resultLabel = descriptionLabel
        
        flex.define { flex in
            flex.addItem(titleLabel).paddingVertical(padding)
            flex.addItem(subTitleLabel).marginBottom(padding)
            flex.addItem(commonTextField).minHeight(40).marginBottom(padding)
            flex.addItem(descriptionLabel).minHeight(20)
        }
        
        textField = commonTextField
        
        flex.layout()
        completionHandler?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

@resultBuilder
struct CommonTextFieldAreaBuilder {
    static func buildFinalResult(_ component: [CommonTextFieldComponents]) -> CommonTextFieldComponents? {
        component.first
    }
    static func buildBlock(_ components: CommonTextFieldComponents...) -> [CommonTextFieldComponents] {
        guard let first = components.first else {
            return []
        }
        
        return [first]
    }
    static func buildArray(_ components: [CommonTextFieldComponents]) -> [CommonTextFieldComponents] {
        guard let first = components.first else {
            return []
        }
        
        return [first]
    }
}

struct CommonTextFieldComponents {
    var key: String
    var title: String
    var subTitle: String?
    var placeHolderString: String?
    var description: String?
    
    var url: URL?
    var optionalTrailingPath: String?
    
    var validateStringCount: UInt = 2
}

extension CommonTextFieldComponents {
    func toRequestType(_ url: URL?, optionalTrailingPath: String? = nil) -> CommonTextFieldComponents {
        var component = self
        component.url = url
        component.optionalTrailingPath = optionalTrailingPath
        
        return component
    }
    
    func setValidateStringCount(_ count: UInt) -> CommonTextFieldComponents {
        var component = self
        component.validateStringCount = count
        
        return component
    }
}
