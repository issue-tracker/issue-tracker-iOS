//
//  IssueAssignee.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/14.
//

import Foundation

struct IssueAssignee: Codable {
    let id: Int
    let email: String
    let nickname: String
    /// image's URL
    let profileImage: String
}
