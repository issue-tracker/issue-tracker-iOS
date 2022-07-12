//
//  HorizontalButtons.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/12.
//

import UIKit
import FlexLayout
import SnapKit

fileprivate typealias Handler = (String)->Void

class HorizontalButtons: UIView {
    
    private let padding: CGFloat = 8
    private let _rootContainer = UIView()
    private(set) var subButtons = [UIButton]()
    
    private var completionHandler: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(
        @HorizontalButtonsBuilder _ content: () -> [HorizontalButtonsComponents],
        _ completionHandler: (()->Void)? = nil
    ) {
        self.init()
        self.completionHandler = completionHandler
        let components = content()
        
        addSubview(_rootContainer)
        
        for (index, component) in components.enumerated() {
            let button = UIButton(type: .custom, primaryAction: component.handler)
            button.setTitle(component.title, for: .normal)
            button.setTitleColor(UIColor.secondaryLabel, for: .normal)
            subButtons.append(button)
            _rootContainer.flex.direction(.row).define { flex in
                flex.addItem(button).grow(1)
                
                if index != components.count - 1 {
                    flex.addItem().width(padding)
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _rootContainer.flex.layout(mode: .adjustHeight)
        completionHandler?()
    }
}

@resultBuilder
public struct HorizontalButtonsBuilder {
    public static func buildBlock(_ components: HorizontalButtonsComponents...) -> [HorizontalButtonsComponents] {
        return components
    }
    
    public static func buildArray(_ components: [HorizontalButtonsComponents]) -> [HorizontalButtonsComponents] {
        return components
    }
}

public struct HorizontalButtonsComponents {
    let title: String
    let handler: UIAction
}
