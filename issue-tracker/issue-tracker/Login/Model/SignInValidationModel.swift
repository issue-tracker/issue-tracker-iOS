//
//  SignInValidationModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/21.
//

import Foundation

class SignInValidationModel {
    typealias Reactor = SignInFormReactor
    typealias STATUS = Reactor.TextFieldStatus
    typealias ID = Reactor.IDState
    typealias PASSWORD = Reactor.PasswordState
    typealias EMAIL = Reactor.EmailState
    typealias NICKNAME = Reactor.NicknameState
    
    private let passwordRegex = try? NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
    
    private var errorMessage: String = "잠시 후 다시 시도해주시기 바랍니다."
    private var warningMessage: String = "입력값을 다시 확인해주시기 바랍니다."
    private var fineMessage: String = "이상이 발견되지 않았습니다."
    private var noNumberMessage: String = "숫자가 포함되어 있지 않습니다."
    private var noAlphabetMessage: String = "영문이 포함되어 있지 않습니다."
    private var notEqualPasswordMessage: String = "비밀번호가 일치하지 않습니다."
    private var notEmailMessage: String = "이메일 형식으로 입력해주시기 바랍니다."
    
    private var notFullfillRangeMessage: (ClosedRange<Int>) -> String = { range in
        return "\(range.lowerBound)~\(range.upperBound)자 이상 입력해주시기 바랍니다."
    }
    private var notEnoughInputMessage: (Int) -> String = { num in
        return "\(num)자 이상 입력해주시기 바랍니다."
    }
    
    /// - Parameters:
    ///     - requestResult: REST API 호출 결과. true가 되려면 http status code가 200이상 300미만이어야 함.
    ///     - id: 입력한 id.
    ///     - isDuplicate: REST API 호출 후 서버에서 중복이라고 하였을 경우 true.
    func checkID(requestResult: Bool, id: String, isDuplicate: Bool) -> ID {
        var statusText = ""
        var resultStatus: STATUS = .none
        let capableInputRange = 4...12
        
        if requestResult == false {
            statusText = errorMessage
            resultStatus = .error
        } else if (capableInputRange ~= id.count) == false {
            statusText = notFullfillRangeMessage(capableInputRange)
            resultStatus = .warning
        } else {
            statusText = isDuplicate ? warningMessage : fineMessage
            resultStatus = isDuplicate ? .warning : .fine
        }
        
        return ID(text: id, status: resultStatus, statusText: statusText)
    }
    
    /// - Parameters:
    ///     - password: 입력한 password.
    func checkPassword(password: String) -> PASSWORD {
        var statusText = fineMessage
        var resultStatus: STATUS = .fine
        
        if password.contains(where: {Int(String($0)) != nil}) == false {
            statusText = noNumberMessage
            resultStatus = .error
        } else if passwordRegex?.firstMatch(in: password, options: [], range: NSMakeRange(0, password.count)) == nil {
            statusText = noAlphabetMessage
            resultStatus = .error
        } else if password.count < 8 {
            statusText = notEnoughInputMessage(8)
            resultStatus = .warning
        }
        
        return PASSWORD(text: password, status: resultStatus, statusText: statusText)
    }
    
    /// - Parameters:
    ///     - password: 입력되어 있는 password.
    ///     - confirmPassword: 확인을 위해 새로 입력한 password.
    func checkConfirmPassword(password: String, confirmPassword: String) -> PASSWORD {
        let status: STATUS = (password == confirmPassword) ? .fine : .warning
        let message = (status == .fine) ? fineMessage : notEqualPasswordMessage
        
        return PASSWORD( text: password, confirmStatus: status, confirmStatusText: message)
    }
    
    /// - Parameters:
    ///     - requestResult: REST API 호출 결과. true가 되려면 http status code가 200이상 300미만이어야 함.
    ///     - email: 입력한 email.
    ///     - isDuplicate: REST API 호출 후 서버에서 중복이라고 하였을 경우 true.
    func checkEmail(requestResult: Bool, email: String, isDuplicate: Bool) -> EMAIL {
        var statusText = ""
        var resultStatus: STATUS = .none
        
        if requestResult == false {
            statusText = errorMessage
            resultStatus = .error
        } else if email.contains(where: { String($0) == "@" || String($0) == "." }) == false {
            statusText = notEmailMessage
            resultStatus = .warning
        } else {
            statusText = isDuplicate ? warningMessage : fineMessage
            resultStatus = isDuplicate ? .warning : .fine
        }
        
        return EMAIL(text: email, status: resultStatus, statusText: statusText)
    }
    
    /// - Parameters:
    ///     - requestResult: REST API 호출 결과. true가 되려면 http status code가 200이상 300미만이어야 함.
    ///     - nickname: 입력한 nickname.
    ///     - isDuplicate: REST API 호출 후 서버에서 중복이라고 하였을 경우 true.
    func checkNickname(requestResult: Bool, nickname: String, isDuplicate: Bool) -> NICKNAME {
        var statusText = ""
        var resultStatus: STATUS = .none
        let capableInputRange = 2...12
        
        if requestResult == false {
            statusText = errorMessage
            resultStatus = .error
        } else if (capableInputRange ~= nickname.count) == false {
            statusText = notFullfillRangeMessage(capableInputRange)
            resultStatus = .warning
        } else {
            statusText = isDuplicate ? warningMessage : fineMessage
            resultStatus = isDuplicate ? .warning : .fine
        }
        
        return NICKNAME(text: nickname, status: resultStatus, statusText: statusText)
    }
    
    func checkRequestEnabled(_ currentState: Reactor.State) -> Int? {
        return currentState.allStatus.firstIndex(where: { $0 == .none || $0 == .error })
    }
}
