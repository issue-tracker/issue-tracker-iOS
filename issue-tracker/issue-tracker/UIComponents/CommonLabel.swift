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
        makeUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    convenience init(frame: CGRect = .zero, _ fontMultiplier: CGFloat) {
        self.init(frame: frame)
        makeUI(fontMultiplier)
    }
    
    private func makeUI(_ fontMultiplier: CGFloat = 1) {
        textColor = .label
        textAlignment = .center
        font = font.withSize(font.pointSize * fontMultiplier)
        
    }
    
    func adaptFamilyFont(with query: String) {
        guard let fontName = UIFont.familyNames.first(where: { $0.contains(query) }) else {
            return
        }
        
        font = UIFont(name: fontName, size: font.pointSize)
    }
}
