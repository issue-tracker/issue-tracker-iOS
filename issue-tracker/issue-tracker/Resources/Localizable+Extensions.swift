//
//  Localizable+Extensions.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/12/13.
//

import Foundation

extension String {
  var localized: String {
    return NSLocalizedString(self, comment: "")
  }
}
