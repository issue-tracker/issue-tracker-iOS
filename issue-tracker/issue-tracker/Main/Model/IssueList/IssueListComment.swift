//
//  IssueListComment.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/14.
//

import Foundation

struct IssueListComment: Codable {
    let id: Int
    let author: IssueListAuthor
    let content: String
    let createdAt: String?
    let issueCommentReactionsResponse: [IssueCommentReactionsResponse]?
}
