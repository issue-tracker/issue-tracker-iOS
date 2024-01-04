//
//  SettingItemRange.swift
//  issue-tracker
//
//  Created by 백상휘 on 2023/02/27.
//

import Foundation

class SettingItemRange: NSObject, NSSecureCoding, Decodable {
    static var supportsSecureCoding: Bool = true
    
    func encode(with coder: NSCoder) {
        coder.encode(minValue, forKey: "minValue")
        coder.encode(currentValue, forKey: "currentValue")
        coder.encode(titlesLocalized, forKey: "titlesLocalized")
        coder.encode(valueUnit, forKey: "valueUnit")
        coder.encode(maxValue, forKey: "maxValue")
    }
    
    let minValue: Int
    var currentValue: Int
    var titlesLocalized: [String]
    let valueUnit: Int
    let maxValue: Int
    
    required convenience init?(coder: NSCoder) {
        let minValue = coder.decodeInteger(forKey: "minValue")
        let currentValue = coder.decodeInteger(forKey: "currentValue")
        let titles = coder.decodeArrayOfObjects(ofClass: NSString.self, forKey: "titlesLocalized")
        let titlesLocalized = titles?.compactMap({ ($0 as String).localized })
        let maxValue = coder.decodeInteger(forKey: "maxValue")
        let valueUnit = coder.decodeInteger(forKey: "valueUnit")
        
        self.init(minValue: minValue, currentValue: currentValue, titlesLocalized: titlesLocalized ?? [], valueUnit: valueUnit, maxValue: maxValue)
    }
    
    init(minValue: Int, currentValue: Int, titlesLocalized: [String], valueUnit: Int, maxValue: Int) {
        self.minValue = minValue
        self.currentValue = currentValue
        self.titlesLocalized = titlesLocalized
        self.valueUnit = valueUnit
        self.maxValue = maxValue
    }
}
