//
//  IssueCommentReactionsResponse.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/14.
//

import Foundation

struct IssueCommentReactionsResponse: Codable {
    let id: Int
    let emoji: String
    let issueCommentReactorResponse: IssueCommentReactorResponse
}
