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
    let openIssueCount: Int
    let closedIssueCount: Int
    let closed: Bool
    
    func getDateCreated() -> Date? {
        guard let dueDate = dueDate else {
            return nil
        }
        
        return DateFormatter().date(from: dueDate)
    }
}

struct MilestoneEntity: Codable, MainListEntity {
    let info: MainListInfo
    init(info: MainListInfo) {
        self.info = info
    }
    
    init(inx: Int) {
        self.info = .init(
            id: inx,
            title: "Test",
            contents: "Contents",
            createdAt: "today?",
            lastModifiedAt: "modifiedDate",
            closed: [true, false].randomElement()!)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.info = try container.decode(MainListInfo.self, forKey: .info)
    }
    
    enum CodingKeys: CodingKey {
        case info
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.info, forKey: .info)
    }
}
