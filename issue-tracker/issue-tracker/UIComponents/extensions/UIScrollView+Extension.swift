//
//  UIScrollView+Extension.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/01.
//

import UIKit

extension UIView {
    var mostUnderNeathView: UIView? {
        self.subviews.max(by: {$0.frame.maxY < $1.frame.maxY})
    }
}

extension UIScrollView {
    func reloadContentSizeHeight() {
        self.contentSize.height = (self.mostUnderNeathView?.frame.maxY ?? 0) + 20
        self.setNeedsLayout()
    }
}
