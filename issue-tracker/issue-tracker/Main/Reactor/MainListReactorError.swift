//
//  MainListReactorError.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/08.
//

import Foundation

enum MainListReactorError: Error {
    case modelURLError
    case decodeAllIssueEntity(String)
    case notMuchIndexForNextPage
}
