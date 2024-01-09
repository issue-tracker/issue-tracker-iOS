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

struct LabelEntity: Codable, MainListEntity {
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
