//
//  URL+Extension.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/29.
//

import Foundation

// Get URL from xcconfig
extension URL {
    
    enum URLServices: String, CaseIterable {
        case github = "Github_Oauth_URL"
        case naver = "Naver_Oauth_URL"
        case kakao = "Kakao_Oauth_URL"
        
        func getURLString() -> String? {
            Bundle.main.object(forInfoDictionaryKey: self.rawValue) as? String
        }
    }
    
    static var githubOauthURL: URL? {
        
        guard let urlString = URLServices.github.getURLString() else {
            return nil
        }
        
        return URL(string: urlString)
    }
    
    static var naverOauthURL: URL? {
        guard let urlString = URLServices.naver.getURLString() else {
            return nil
        }
        
        return URL(string: urlString)
    }
    
    static var kakaoOauthURL: URL? {
        guard let urlString = URLServices.kakao.getURLString() else {
            return nil
        }
        
        return URL(string: urlString)
    }
    
    static var allAuthenticationURLs: [URL]? {
        [githubOauthURL, naverOauthURL, kakaoOauthURL] as? [URL]
    }
    
    func getService() -> URLServices? {
        let host = self.host
        
        for service in URLServices.allCases {
            if String(describing: service).uppercased() == host?.uppercased() {
                return service
            }
        }
        
        return nil
    }
}
