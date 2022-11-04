//
//  AuthResponse.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/31.
//

import Foundation

struct AuthResponse: Decodable {
    let signUpFormData: SignUpFormData?
    let signInMember: SignInMember?
    let accessToken: AccessToken
}

struct SignUpFormData: Decodable {
    let resourceOwnerId: String
    let email: String
    let profileImage: String
}

struct SignInMember: Decodable {
    let id: Int
    let email: String
    let nickname: String
    let profileImage: String
}
