//
//  IssueHistories.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/22.
//

import Foundation

struct IssueHistories: Decodable {
    
    let modifier: IssueListAuthor
    let modifiedAt: String
    let action: String
    let label: LabelListEntity
    let milestone: MilestoneInIssueEntity
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        modifier = try values.decode(IssueListAuthor.self, forKey: .modifier)
        modifiedAt = try values.decode(String.self, forKey: .modifiedAt)
        action = try values.decode(String.self, forKey: .action)
        label = try values.decode(LabelListEntity.self, forKey: .label)
        milestone = try values.decode(MilestoneInIssueEntity.self, forKey: .milestone)
    }
    
    enum CodingKeys: String, CodingKey {
        case modifier, modifiedAt, action, label, milestone
    }
}
