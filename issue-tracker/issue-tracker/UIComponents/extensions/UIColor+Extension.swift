//
//  UIColor+Extension.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/26.
//

import UIKit

extension UIColor {
    static func getRandomColor() -> UIColor {
        var colorValue: CGFloat {
            CGFloat.random(in: 0...255) / CGFloat(255)
        }
        
        return UIColor(
            displayP3Red: colorValue,
            green: colorValue,
            blue: colorValue,
            alpha: 1.0
        )
    }
}
