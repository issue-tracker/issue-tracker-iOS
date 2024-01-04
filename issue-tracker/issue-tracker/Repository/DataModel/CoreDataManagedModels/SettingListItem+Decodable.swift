//
//  SettingListItem+Decodable.swift
//  issue-tracker
//
//  Created by 백상휘 on 2023/02/06.
//

import Foundation

struct SettingDecodable: Decodable {
    var contents: [SettingCategoryDecodable]
    
    enum CodingKeys: CodingKey {
        case contents
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.contents = try container.decode([SettingCategoryDecodable].self, forKey: .contents)
    }
}

struct SettingCategoryDecodable: Decodable {
    var title: String
    var listTypeValue: Int
    var items: [SettingListDecodable]
    
    enum CodingKeys: CodingKey {
        case title
        case listTypeValue
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.listTypeValue = try container.decode(Int.self, forKey: .listTypeValue)
        self.items = try container.decode([SettingListDecodable].self, forKey: .items)
    }
}

struct SettingListDecodable: Decodable {
    var title: String
    var values: [SettingListItemDecodable]
    
    enum CodingKeys: CodingKey {
        case title
        case values
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.values = try container.decode([SettingListItemDecodable].self, forKey: .values)
    }
}

struct SettingListItemDecodable: Decodable {
    var mainTitle: String
    var subTitle: String
    var desc: String
    var order: Int
    var typeName: String
    var value: Any?
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case mainTitle, subTitle, desc, order, typeName, value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.mainTitle = try container.decode(String.self, forKey: .mainTitle)
        self.subTitle = try container.decode(String.self, forKey: .subTitle)
        self.desc = try container.decode(String.self, forKey: .desc)
        self.order = try container.decode(Int.self, forKey: .order)
        self.typeName = try container.decode(String.self, forKey: .typeName)
      
        if let value = try? container.decodeIfPresent(SettingItemColor.self, forKey: .value) {
            // MARK: - Decoding Failed. JSON looks fine.
            self.value = value
        } else if let value = try? container.decodeIfPresent(SettingItemLoginActivate.self, forKey: .value) {
            // MARK: - Decoding Failed. JSON looks fine.
            self.value = value
        } else if let value = try? container.decodeIfPresent(SettingItemRange.self, forKey: .value) {
            value.titlesLocalized = value.titlesLocalized.map({$0.localized})
            self.value = value
        } else if let value = try? container.decodeIfPresent(Bool.self, forKey: .value) {
            self.value = value
        } else if let value = try? container.decodeIfPresent(Int.self, forKey: .value) {
            // MARK: - Decoding Failed. JSON looks fine.
            self.value = value
        } else {
            self.value = nil
        }
    }
}

enum DarkModeSettings: Int, Codable, CaseIterable {
    case system = 0
    case light = 1
    case dark = 2
}

enum SocialType: String, CaseIterable {
    case github, kakao, naver
}

enum LanguageSettings: String, CaseIterable {
    case english, japanese, korean
}
