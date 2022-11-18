//
//  HTTPURLResponse+Extensions.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/18.
//

import Foundation

extension HTTPURLResponse {
    var isSuccess: Bool {
        return (200..<300 ~= self.statusCode)
    }
}
