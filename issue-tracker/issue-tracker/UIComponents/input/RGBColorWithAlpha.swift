//
//  RGBColorWithAlpha.swift
//  issue-tracker
//
//  Created by 백상휘 on 2024/01/09.
//

import Foundation

struct RGBColorWithAlpha {
    @RGBColorValue var red: Float
    @RGBColorValue var green: Float
    @RGBColorValue var blue: Float
    @RGBAlphaValue var alpha: Float
}

@propertyWrapper struct RGBColorValue {
    private var _wrappedValue: Float = 0.0
    var wrappedValue: Float {
        get { _wrappedValue }
        set {
            if (0.0...255.0) ~= newValue {
                _wrappedValue = newValue
            }
        }
    }
    
    init(wrappedValue: Float) {
        self._wrappedValue = wrappedValue
    }
}

@propertyWrapper struct RGBAlphaValue {
    private var _wrappedValue: Float = 0.0
    var wrappedValue: Float {
        get { _wrappedValue }
        set {
            if (0.0...10.0) ~= newValue {
                _wrappedValue = newValue
            }
        }
    }
    
    init(wrappedValue: Float) {
        self._wrappedValue = wrappedValue
    }
}
