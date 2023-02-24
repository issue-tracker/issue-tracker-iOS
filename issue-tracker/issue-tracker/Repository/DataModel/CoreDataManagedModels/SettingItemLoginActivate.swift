//
//  SettingItemLoginActivate.swift
//  issue-tracker
//
//  Created by 백상휘 on 2023/02/23.
//

import Foundation

class SettingItemLoginActivate: NSObject, NSSecureCoding, Decodable {
    static var supportsSecureCoding: Bool = true
    
    func encode(with coder: NSCoder) {
        coder.encode(github, forKey: "github")
        coder.encode(kakao, forKey: "kakao")
        coder.encode(naver, forKey: "naver")
    }
    
    required convenience init?(coder: NSCoder) {
        let github = coder.decodeBool(forKey: "github")
        let kakao = coder.decodeBool(forKey: "kakao")
        let naver = coder.decodeBool(forKey: "naver")
        
        self.init(github: github, kakao: kakao, naver: naver)
    }
    
    var github = true
    var kakao = true
    var naver = true
    
    init(github: Bool = false, kakao: Bool = false, naver: Bool = false) {
        self.github = github
        self.kakao = kakao
        self.naver = naver
    }
    
    var allCases: [Bool] {[
        github, kakao, naver
    ]}
}
