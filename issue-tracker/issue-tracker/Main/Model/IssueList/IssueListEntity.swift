//
//  IssueListEntity.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/11.
//

import Foundation

struct AllIssueEntity: Codable {
    let openIssueCount: Int
    let openIssues: [IssueListEntity]
    let closedIssueCount: Int
    let closedIssues: [IssueListEntity]
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        openIssueCount = try values.decode(Int.self, forKey: .openIssueCount)
        closedIssueCount = try values.decode(Int.self, forKey: .closedIssueCount)
        
        if let container = try? values.nestedContainer(keyedBy: IssueContentCodingkeys.self, forKey: .openIssues) {
            openIssues = try container.decode([IssueListEntity].self, forKey: .content)
        } else {
            openIssues = try values.decode([IssueListEntity].self, forKey: .openIssues)
        }
        
        if let container = try? values.nestedContainer(keyedBy: IssueContentCodingkeys.self, forKey: .closedIssues) {
            closedIssues = try container.decode([IssueListEntity].self, forKey: .content)
        } else {
            closedIssues = try values.decode([IssueListEntity].self, forKey: .closedIssues)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case openIssueCount, openIssues, closedIssueCount, closedIssues
    }
    
    enum IssueContentCodingkeys: String, CodingKey {
        case content
    }
}

struct IssueListEntity: Codable {
    let id: Int
    let title: String
    let createdAt: String?
    let author: IssueListAuthor
    let comments: [IssueListComment]
    let issueAssignees: [IssueAssignee]
    let issueLabels: [LabelListEntity]
    let milestone: MilestoneListEntity?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(Int.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        createdAt = try? values.decode(String.self, forKey: .createdAt)
        author = try values.decode(IssueListAuthor.self, forKey: .author)
        comments = try values.decode([IssueListComment].self, forKey: .comments)
        
        if let assigneeContainer = try? values.nestedContainer(keyedBy: AssigneesCodingKeys.self, forKey: .issueAssignees) {
            issueAssignees = try assigneeContainer.decode([IssueAssignee].self, forKey: .issueAssignees)
        } else {
            issueAssignees = try values.decode([IssueAssignee].self, forKey: .issueAssignees)
        }
        
        if let labelsContainer = try? values.nestedContainer(keyedBy: LabelsCodingKeys.self, forKey: .issueLabels) {
            issueLabels = try labelsContainer.decode([LabelListEntity].self, forKey: .issueLabels)
        } else {
            issueLabels = try values.decode([LabelListEntity].self, forKey: .issueLabels)
        }
        
        milestone = try? values.decode(MilestoneListEntity.self, forKey: .milestone)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(author, forKey: .author)
        try container.encode(comments, forKey: .comments)
        try container.encode(issueAssignees, forKey: .issueAssignees)
        try container.encode(issueLabels, forKey: .issueLabels)
        try container.encode(milestone, forKey: .milestone)
    }
    
    func getDateCreated() -> Date? {
        guard let createdAt = createdAt else {
            return nil
        }

        return DateFormatter().date(from: createdAt)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, createdAt, author, comments, issueAssignees, issueLabels, milestone
    }
    
    enum AssigneesCodingKeys: String, CodingKey {
        case issueAssignees
    }
    
    enum LabelsCodingKeys: String, CodingKey {
        case issueLabels
    }
}

