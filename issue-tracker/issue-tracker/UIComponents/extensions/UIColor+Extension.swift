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
    
    convenience init?(hex: String) {
        let r, g, b: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat((hexNumber & 0x0000ff)) / 255

                    self.init(red: r, green: g, blue: b, alpha: 1)
                    return
                }
            }
        }

        return nil
    }
    
    convenience init?(settingItem item: SettingItemColor) {
        let enableRange: ClosedRange<Float> = 0...255
        
        guard
            enableRange ~= item.rgbRed,
            enableRange ~= item.rgbGreen,
            enableRange ~= item.rgbBlue
        else {
            return nil
        }
        
        self.init(
            red: CGFloat(item.rgbRed) / 255,
            green: CGFloat(item.rgbGreen) / 255,
            blue: CGFloat(item.rgbBlue) / 255,
            alpha: 1
        )
    }
}
