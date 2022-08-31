//
//  MilestoneEntity.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/29.
//

import Foundation

struct AllMilestoneEntity: Codable {
    let openedMilestones: [MilestoneEntity]
    let closedMilestones: [MilestoneEntity]
}

struct MilestoneEntity: Codable {
    let id: Int
    let title: String
    let description: String
    let dueDate: String
    let closed: Bool
}
