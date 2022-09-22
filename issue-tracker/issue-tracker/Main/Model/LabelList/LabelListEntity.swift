//
//  LabelListEntity.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/29.
//

import Foundation

struct LabelListEntity: Codable {
    let id: Int
    let title: String
    let backgroundColorCode: String
    let description: String
    let textColor: String
    let createdAt: String?
    let lastModifiedAt: String?
}
