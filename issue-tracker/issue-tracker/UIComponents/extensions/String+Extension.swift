//
//  String+Extension.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/26.
//

import Foundation

extension String {
    func queryEncoded() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "+:%").inverted) ?? self
    }
}
