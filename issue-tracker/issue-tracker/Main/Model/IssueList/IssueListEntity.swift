//
//  IssueListEntity.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/11.
//

import Foundation

protocol EntityContainsResultList {
    var list: [Any]? { get }
}

struct AllIssueEntity: Codable, EntityContainsResultList {
    
    let openIssueCount: Int
    let closedIssueCount: Int
    let issues: [IssueListEntity]
    
    var list: [Any]? {
        self.issues
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        openIssueCount = try values.decode(Int.self, forKey: .openIssueCount)
        closedIssueCount = try values.decode(Int.self, forKey: .closedIssueCount)
        
        if let container = try? values.nestedContainer(keyedBy: IssueContentCodingkeys.self, forKey: .issues) {
            issues = try container.decode([IssueListEntity].self, forKey: .content)
        } else {
            issues = try values.decode([IssueListEntity].self, forKey: .issues)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case openIssueCount, closedIssueCount, issues
    }
    
    enum IssueContentCodingkeys: String, CodingKey {
        case content
    }
}

struct IssueListEntity: Codable {
    let id: Int
    let title: String
    
    let author: IssueListAuthor
    let comments: [IssueListComment]
    let issueAssignees: [IssueAssignee]
    let issueLabels: [LabelListEntity]
    let milestone: MilestoneListEntity?
    let issueHistories: [IssueHistories]?
    
    let createdAt: String?
    let lastModifiedAt: String?
    let closed: Bool
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(Int.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
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
        issueHistories = try? values.decode([IssueHistories].self, forKey: .issueHistories)
        
        createdAt = try? values.decode(String.self, forKey: .createdAt)
        lastModifiedAt = try? values.decode(String.self, forKey: .lastModifiedAt)
        closed = try values.decode(Bool.self, forKey: .closed)
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
        case id, title, author, comments, issueAssignees, issueLabels, milestone, issueHistories, createdAt, lastModifiedAt, closed
    }
    
    enum AssigneesCodingKeys: String, CodingKey {
        case issueAssignees
    }
    
    enum LabelsCodingKeys: String, CodingKey {
        case issueLabels
    }
}

