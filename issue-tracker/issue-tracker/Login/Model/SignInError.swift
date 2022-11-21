//
//  SignInError.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/17.
//

import Foundation

enum SignInError: String, Error {
    case idError = "아이디를 다시 확인해주시기 바랍니다."
    case passwordError = "비밀번호를 다시 확인해주시기 바랍니다."
    case emailError = "이메일을 다시 확인해주시기 바랍니다."
    case nicknameError = "닉네임을 다시 확인해주시기 바랍니다."
    case unknownError = "확인되지 않은 오류입니다."
    case urlError = "일시적인 오류입니다."
    
    static func getErrorMessage(from index: Int) -> String {
        switch index {
        case 0: return SignInError.idError.rawValue
        case 1: return SignInError.passwordError.rawValue
        case 2: return SignInError.emailError.rawValue
        case 3: return SignInError.nicknameError.rawValue
        default: return SignInError.unknownError.rawValue
        }
    }
}
