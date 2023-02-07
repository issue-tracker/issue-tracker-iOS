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
    var order: Int
    var value: Any?
    
    enum CodingKeys: CodingKey {
        case mainTitle
        case subTitle
        case order
        case value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.mainTitle = try container.decode(String.self, forKey: .mainTitle)
        self.subTitle = try container.decode(String.self, forKey: .subTitle)
        self.order = try container.decode(Int.self, forKey: .order)
      
        if let value = try? container.decodeIfPresent(Bool.self, forKey: .value) {
            self.value = value
        } else if let value = try? container.decodeIfPresent(ColorSets.self, forKey: .value) {
            // MARK: - Decoding Failed. JSON looks fine.
            self.value = value
        } else {
            self.value = nil
        }
    }
}

struct ColorSets: Decodable {
    var rgbRed: Float
    var rgbGreen: Float
    var rgbBlue: Float
    
    enum CodingKeys: CodingKey {
        case rgbRed
        case rgbGreen
        case rgbBlue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rgbRed = try container.decode(Float.self, forKey: .rgbRed)
        self.rgbGreen = try container.decode(Float.self, forKey: .rgbGreen)
        self.rgbBlue = try container.decode(Float.self, forKey: .rgbBlue)
    }
}
