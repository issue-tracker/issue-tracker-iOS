//
//  SignInBuilder.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/18.
//

import FlexLayout

class SignInFormBuilder: CommonProxyViewController, ViewBinding {
    
    private let padding: CGFloat = 8
    private(set) var commonTextFieldDict = [String: CommonTextField]()
    
    var bindableHandler: ((Any?, ViewBindable) -> Void)? = { param, bindable in
        guard let param = param as? [String: Any] else { return }
        
        if let descriptionLabel = bindable as? DescriptionLabel, let result = param["result"] as? ResponseStatus {
            
            descriptionLabel.popLoading(result.isRequesting)
            descriptionLabel.setResponseStatus(result)
        }
    }
    
    func getCommonTextFieldArea(
        key: String,
        title: String,
        subTitle: String? = nil,
        placeHolderString: String? = nil,
        urlPath: String? = nil,
        optionalTrailingPath: String? = nil,
        description: String? = nil
    ) -> UIView {
        let areaView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.attributedText = NSAttributedString(string: title, attributes: [.font: UIFont.preferredFont(forTextStyle: .headline, compatibleWith: nil)])
        
        let subTitleLabel = UILabel()
        let subTitleFont = UIFont.preferredFont(forTextStyle: .subheadline)
        subTitleLabel.font = UIFont.boldSystemFont(ofSize: subTitleFont.pointSize)
        subTitleLabel.text = subTitle
        subTitleLabel.adjustsFontSizeToFitWidth = true
        
        var commonTextField = CommonTextField(frame: .zero, input: .default, placeholder: placeHolderString)
        if let urlPath = urlPath {
            commonTextField = commonTextField.toRequestType(url: URL.membersApiURL?.appendingPathComponent(urlPath), optionalTrailingPath: optionalTrailingPath)
        }
        commonTextField.binding = self
        commonTextFieldDict[key] = commonTextField
        
        let descriptionLabel = DescriptionLabel()
        descriptionLabel.binding = self
        let descriptionFont = UIFont.preferredFont(forTextStyle: .subheadline)
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: descriptionFont.pointSize)
        descriptionLabel.text = description ?? " "
        subTitleLabel.adjustsFontSizeToFitWidth = true
        
        (commonTextField as? RequestTextField)?.resultLabel = descriptionLabel
        
        view.addSubview(areaView)
        areaView.flex.define { flex in
            flex.addItem(titleLabel).paddingVertical(padding)
            flex.addItem(subTitleLabel).marginBottom(padding)
            flex.addItem(commonTextField).minHeight(40).marginBottom(padding)
            flex.addItem(descriptionLabel)
        }
        
        return areaView
    }
    
    func getAllTextFieldValues() -> [String: String] {
        var result = [String: String]()
        for item in commonTextFieldDict {
            if let text = item.value.text {
                result[item.key] = text
            }
        }
        
        return result
    }
}
