//
//  CommonLabel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/11.
//

import UIKit

enum CommonLabelFontStyle {
    case bold
    case italic
    
}

class CommonLabel: UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI(1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI(1)
    }
    
    convenience init(text: String? = nil, frame: CGRect = .zero, fontMultiplier: CGFloat = 1) {
        self.init(frame: frame)
        self.text = text
        makeUI(fontMultiplier)
    }
    
    private func makeUI(_ fontMultiplier: CGFloat) {
        textColor = .label
        textAlignment = .center
        font = font.withSize(font.pointSize * fontMultiplier)
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.1
    }
    
    func adaptFamilyFont(with query: String) {
        guard let fontName = UIFont.familyNames.first(where: { $0.contains(query) }) else {
            return
        }
        
        font = UIFont(name: fontName, size: font.pointSize)
    }
}
