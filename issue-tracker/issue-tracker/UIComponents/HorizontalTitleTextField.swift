//
//  HorizontalTitleTextField.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/12.
//

import UIKit
import FlexLayout
import SnapKit

class HorizontalTitleTextField: UIView {
    
    private let rootContainer = UIView()
    let titleLabel = UILabel()
    let textField = UITextField()
    var padding: CGFloat = 8
    
    private var completionHandler: ((HorizontalTitleTextField)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @discardableResult
    convenience public init(
        @HorizontalTitleTextFieldBuilder _ content: () -> HorizontalTitleTextFieldComponents,
        _ completionHandler: ((HorizontalTitleTextField)->Void)? = nil
    ) {
        self.init()
        let contents = content()
        
        addSubview(rootContainer)
        
        titleLabel.text = contents.title
        textField.borderStyle = .roundedRect
        
        rootContainer.flex.direction(.row).define { flex in
            flex.addItem(titleLabel).width(30%)
            flex.addItem(textField).width(70%)
        }
        
        self.completionHandler = completionHandler
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootContainer.flex.layout(mode: .adjustHeight)
        completionHandler?(self)
    }
}

@resultBuilder
public struct HorizontalTitleTextFieldBuilder {
    public static func buildBlock(_ components: String...) -> HorizontalTitleTextFieldComponents {
        guard let title = components.first else {
            fatalError("[HorizontalTitleTextFieldBuilder] No Title for HorizontalTitleTextField.")
        }
        
        return HorizontalTitleTextFieldComponents(title: title)
    }
    public static func buildExpression(_ expression: HorizontalTitleTextFieldComponents) -> HorizontalTitleTextFieldComponents {
        return expression
    }
}

public struct HorizontalTitleTextFieldComponents {
    let title: String
}


