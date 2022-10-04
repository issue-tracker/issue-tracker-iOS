//
//  HTTPCookieStorage+Extensions.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/04.
//

import Foundation

extension HTTPCookieStorage {
    var refreshToken: String? {
        cookies?.first(where: { $0.name == "refresh_token" })?.value
    }
}
