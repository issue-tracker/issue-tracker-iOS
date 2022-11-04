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
        
        func getProvider() -> String {
            switch self {
            case .github: return "GITHUB"
            case .naver: return "NAVER"
            case .kakao: return "KAKAO"
            }
        }
    }
    
    static var apiURL: URL? {
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else {
            return nil
        }
        
        return URL(string: urlString)
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
    
    static var membersApiURL: URL? {
        URL.apiURL?.appendingPathComponent("members")
    }
    
    static var authApiURL: URL? {
        URL.apiURL?.appendingPathComponent("auth")
    }
    
    static var issueApiURL: URL? {
        URL.apiURL?.appendingPathComponent("issues")
    }
    
    static var labelApiURL: URL? {
        URL.apiURL?.appendingPathComponent("labels")
    }
    
    static var milestoneApiURL: URL? {
        URL.apiURL?.appendingPathComponent("milestones")
    }
    
    static var imageApiURL: URL? {
        URL.apiURL?.appendingPathComponent("images")
    }
}
