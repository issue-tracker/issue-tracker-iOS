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

extension CGPoint: AdditiveArithmetic {
    
    public static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x-rhs.x, y: lhs.y-rhs.y)
    }
    
    public static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x+rhs.x, y: lhs.y+rhs.y)
    }
}

extension UIScrollView {
    func absolutePosition(of view: UIView) -> CGPoint {
        var superViewContainer = view.superview
        var result = view.frame.origin
        
        while superViewContainer != self, superViewContainer != nil {
            result += superViewContainer!.frame.origin
            superViewContainer = superViewContainer?.superview
        }
        
        return result
    }
}
