//
//  issue_tracker_SignInCases.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/22.
//

import Foundation

struct SignInCases {
    let idTestSuccessCases = ["testios", "testio", "12341234", "T$#@$hj"]
    let idTestFailableCases = ["1", "testios1234567890"]
    let passwordSuccessCases = ["12341234", "abcd1234", "ABcD!@34"]
    let passwordFailableCases = ["12", ""]
    let passwordConfirmSuccessCases = ["12341234", "abcd1234", "ABcD!@34"]
    let emailSuccessCases = ["abc@gmaill.com", "jagjayo@naver.com"]
    let emailFailableCases = ["abc.gamil.com", "jagjayo@naver@com", "abc.gmail@com"]
    let nicknameSuccessCases = ["abc"]
    let nicknameFailableCases = ["testios1234567890"]
    
    var fullfillmentCount: Int {
        idTestSuccessCases.count + passwordSuccessCases.count + passwordConfirmSuccessCases.count + emailSuccessCases.count + nicknameSuccessCases.count
    }
}
