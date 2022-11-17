//
//  SignInError.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/17.
//

import Foundation

enum SignInError: Error {
    case idError
    case passwordError
    case emailError
    case nicknameError
    case unknownError
    
    static func getError(from index: Int) -> SignInError {
        switch index {
        case 0: return .idError
        case 1: return .passwordError
        case 2: return .emailError
        case 3: return .nicknameError
        default: return .unknownError
        }
    }
}
