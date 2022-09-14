//
//  IssueDetailCellCommonHeight.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/14.
//

import Foundation

protocol IssueDetailCellCommonHeight {
    func getHeight() -> Float
    func setEntity(_ entity: IssueListComment)
}
