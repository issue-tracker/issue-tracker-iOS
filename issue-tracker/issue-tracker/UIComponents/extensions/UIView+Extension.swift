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
        self.clipsToBounds = true
        self.setNeedsDisplay()
    }
}
