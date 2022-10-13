//
//  UITableViewCell+Extensions.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/13.
//

import UIKit

extension UITableViewCell {
    var reuseIdentifier: String? {
        String(describing: Self.self)
    }
}
