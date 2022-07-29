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
    private var completionHandler: (()->Void)?
    
    private(set) var subButtons = [UIButton]()
    
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
        
        for component in components {
            
            let button = UIButton(type: .custom, primaryAction: component.handler)
            button.frame.size = CGSize(width: bounds.height, height: bounds.height)
            if let title = component.title {
                button.setTitle(title, for: .normal)
                button.setTitleColor(UIColor.secondaryLabel, for: .normal)
            } else if let imageName = component.imageName {
                button.setImage(UIImage(named: imageName), for: .normal)
                button.contentMode = .scaleAspectFit
            }
            
            subButtons.append(button)
            flex.direction(.row).alignContent(.center).define { flex in
                flex.addItem(button)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        flex.layout()
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
    let title: String?
    let imageName: String?
    let handler: UIAction?
    
    init(title: String? = nil, imageName: String? = nil, handler: UIAction? = nil) {
        self.title = title
        self.imageName = imageName
        self.handler = handler
    }
}
