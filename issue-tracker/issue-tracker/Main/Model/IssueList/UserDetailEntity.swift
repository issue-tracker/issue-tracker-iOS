//
//  UserDetailEntity.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/22.
//

import Foundation

struct UserDetailEntity: Decodable {
    let createdAt: String
    let lastModifiedAt: String
    let id: Int
    let signInId: String
    let password: String
    let email: String
    let nickname: String
    let profileImage: String
    let authProviderType: String
    let resourceOwnerId: String
}
