//
//  MilestoneListEntity.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/29.
//

import Foundation

struct AllMilestoneEntity: Codable {
    let openedMilestones: [MilestoneListEntity]
    let closedMilestones: [MilestoneListEntity]
}

struct MilestoneListEntity: Codable {
    let id: Int
    let title: String
    let description: String?
    let dueDate: String?
    let closed: Bool
    
    func getDateCreated() -> Date? {
        guard let dueDate = dueDate else {
            return nil
        }
        
        return DateFormatter().date(from: dueDate)
    }
}
