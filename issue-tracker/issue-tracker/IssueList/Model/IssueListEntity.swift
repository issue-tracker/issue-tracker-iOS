//
//  IssueListEntity.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/11.
//

import Foundation

enum IssueStatus: Int {
    case opened = 0
    case closed = 1
    case standby = 2
}

struct IssueListEntity: Codable {
    let key: UUID
    let title: String
    var status: IssueStatus = .standby
    let contents: String
    let dateCreated: String
    var comments: [IssueListComment]
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        key = try values.decode(UUID.self, forKey: .key)
        title = try values.decode(String.self, forKey: .title)
        
        let statusCode = try values.decode(Int.self, forKey: .status)
        
        switch statusCode {
        case 0: status = .opened
        case 1: status = .closed
        default: status = .standby
        }
        
        contents = try values.decode(String.self, forKey: .contents)
        dateCreated = try values.decode(String.self, forKey: .dateCreated)
        comments = try values.decode([IssueListComment].self, forKey: .comments)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(key, forKey: .key)
        try container.encode(title, forKey: .title)
        try container.encode(status.rawValue, forKey: .status)
        try container.encode(contents, forKey: .contents)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(comments, forKey: .comments)
    }
    
    init(key: UUID, title: String, status: IssueStatus? = nil, contents: String, dateCreated: Date? = nil, comments: [IssueListComment]? = nil) {
        self.key = key
        self.title = title
        self.contents = contents
        
        if let status = status {
            self.status = status
        }
        
        self.dateCreated = DateFormatter.localizedString(from: dateCreated ?? Date(), dateStyle: .long, timeStyle: .full)
        self.comments = comments ?? Array.init(repeating: IssueListComment(), count: Int.random(in: 0...6))
    }
    
    func getDateCreated() -> Date? {
        DateFormatter().date(from: dateCreated)
    }
    
    enum CodingKeys: String, CodingKey {
        case key
        case title
        case status
        case contents
        case dateCreated
        case comments
    }
}

struct IssueListComment: Codable {
    
}
