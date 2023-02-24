//
//  SettingItemColor.swift
//  issue-tracker
//
//  Created by 백상휘 on 2023/02/23.
//

import Foundation

class SettingItemColor: NSObject, NSSecureCoding, Decodable {
    static var supportsSecureCoding: Bool = true
    
    func encode(with coder: NSCoder) {
        coder.encode(rgbRed, forKey: "rgbRed")
        coder.encode(rgbGreen, forKey: "rgbGreen")
        coder.encode(rgbBlue, forKey: "rgbBlue")
    }
    
    required convenience init?(coder: NSCoder) {
        let rgbRed = coder.decodeFloat(forKey: "rgbRed")
        let rgbGreen = coder.decodeFloat(forKey: "rgbGreen")
        let rgbBlue = coder.decodeFloat(forKey: "rgbBlue")
        
        self.init(rgbRed: rgbRed, rgbGreen: rgbGreen, rgbBlue: rgbBlue)
    }
    
    var rgbRed: Float
    var rgbGreen: Float
    var rgbBlue: Float
    
    init(rgbRed: Float, rgbGreen: Float, rgbBlue: Float) {
        self.rgbRed = rgbRed
        self.rgbGreen = rgbGreen
        self.rgbBlue = rgbBlue
    }
    
    static func getTitle(_ index: Int) -> String? {
        guard 0..<RGBColor.allCases.count ~= index else {
            return nil
        }
        
        return RGBColor.allCases[index].rawValue
    }
}

