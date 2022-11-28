//
//  CommonTextField+Extensions.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/25.
//

import UIKit

extension CommonTextField {
    func toRequestType(url: URL?, optionalTrailingPath: String? = nil) -> RequestTextField {
        let textField = RequestTextField(frame: frame, input: keyboardType, placeholder: placeholder, markerType: markerType)
        textField.requestURL = url
        textField.delegate = textField
        textField.optionalTrailingPath = optionalTrailingPath
        return textField
    }
}
