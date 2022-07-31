//
//  NSAttributedString+Extension.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/28.
//

import UIKit

extension NSAttributedString {
    static func blackString(_ string: String) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: [.foregroundColor: UIColor.black])
    }
    
    static func blackOpaqueString(_ string: String) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: [.foregroundColor: UIColor.black.withAlphaComponent(0.5)])
    }
}
