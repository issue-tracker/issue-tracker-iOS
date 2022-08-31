//
//  IssueListEntity.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/11.
//

import Foundation

struct IssueListEntity: Codable {
    let id: Int
    let title: String
    let createdAt: String?
    let author: IssueListAuthor
    let comments: [IssueListComment]
    let issueAssignees: [IssueAssignee]
    let issueLabels: [IssueLabel]
    let milestone: IssueMilestone
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(Int.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        createdAt = try values.decode(String.self, forKey: .createdAt)
        author = try values.decode(IssueListAuthor.self, forKey: .author)
        comments = try values.decode([IssueListComment].self, forKey: .comments)
        
        if let assigneeContainer = try? values.nestedContainer(keyedBy: AssigneesCodingKeys.self, forKey: .issueAssignees) {
            issueAssignees = try assigneeContainer.decode([IssueAssignee].self, forKey: .issueAssignees)
        } else {
            issueAssignees = try values.decode([IssueAssignee].self, forKey: .issueAssignees)
        }
        
        if let labelsContainer = try? values.nestedContainer(keyedBy: LabelsCodingKeys.self, forKey: .issueLabels) {
            issueLabels = try labelsContainer.decode([IssueLabel].self, forKey: .issueLabels)
        } else {
            issueLabels = try values.decode([IssueLabel].self, forKey: .issueLabels)
        }
        
        milestone = try values.decode(IssueMilestone.self, forKey: .milestone)
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

struct IssueListComment: Codable {
    let id: Int
    let author: IssueListAuthor
    let content: String
    let createdAt: String?
    let issueCommentReactionsResponse: [IssueCommentReactionsResponse]
}

struct IssueListAuthor: Codable {
    let id: Int
    let email: String
    let nickname: String
    /// image's URL
    let profileImage: String
}

struct IssueCommentReactionsResponse: Codable {
    let id: Int
    let emoji: String
    let issueCommentReactorResponse: IssueCommentReactorResponse
}

struct IssueCommentReactorResponse: Codable {
    let id: Int
    let nickname: String
}

struct IssueAssignee: Codable {
    let id: Int
    let email: String
    let nickname: String
    /// image's URL
    let profileImage: String
}

struct IssueLabel: Codable {
    let id: Int
    let title: String
    /// hex-color
    let backgroundColorCode: String
    let description: String
    let textColor: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        backgroundColorCode = try container.decode(String.self, forKey: .backgroundColorCode)
        description = try container.decode(String.self, forKey: .description)
        textColor = try container.decode(String.self, forKey: .textColor)
    }
    
    enum CodingKeys: String, CodingKey {
    case id,title,backgroundColorCode,description,textColor
    }
}

struct IssueMilestone: Codable {
    let id: Int
    let title: String
    let description: String?
    let dueDate: String?
    let closed: Bool
}