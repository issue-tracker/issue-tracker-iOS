//
//  UIView+Extension.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/02.
//

import UIKit

extension UIView {
    func makeCircle() {
        self.layer.cornerRadius = min(self.frame.height, self.frame.width)/2
        self.layer.masksToBounds = false
        self.setNeedsDisplay()
    }
    
    func setCornerRadius(_ radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.height/4
        self.layer.masksToBounds = false
        self.setNeedsDisplay()
    }
    
    func setShadow(dx: CGFloat = 5, dy: CGFloat = 5, radius: CGFloat? = nil) {
        let shadowRect = bounds.offsetBy(dx: dx, dy: dy)
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = .zero
        layer.shadowRadius = radius ?? self.frame.height/4
        layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
    }
}
