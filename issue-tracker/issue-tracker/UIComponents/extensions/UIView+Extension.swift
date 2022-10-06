//
//  UIView+Extension.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/02.
//

import UIKit

extension UIView {
    func setCornerRadius(_ radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.height/4
        self.layer.masksToBounds = false
        self.setNeedsDisplay()
    }
    
    func setShadow(dx: CGFloat = 5, dy: CGFloat = 5) {
        let shadowRect = bounds.offsetBy(dx: dx, dy: dy)
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = .zero
        layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
    }
}
