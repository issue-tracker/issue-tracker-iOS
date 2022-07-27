//
//  LoginModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/26.
//

import Foundation

class LoginModel {
    
    func validateLoginSocial(openURL url: URL?) -> Result<Bool, Error> {
        
        guard
            let url = url,
            let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true),
            urlComponents.host == "login"
        else {
            return .failure(LoginValidationError.urlError)
        }
        
        let path = urlComponents.path.lowercased()
        var loginParameters: [String: String] = [:]
        
        for social in SocialType.allCases {
            if path.contains(social.rawValue) {
                loginParameters["vendor"] = social.rawValue
                return .success(true)
            }
        }
        
        return .failure(LoginValidationError.noneCase)
    }
    
    func requestLogin(param: LoginEntity, _ completionHandler: @escaping (Result<Data?, Error>)->Void) {
        
        guard let url = URL(string: ""), let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
            completionHandler(.failure(LoginValidationError.urlError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpBody = try? JSONEncoder().encode(param)
        request.addValue(accessToken, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            completionHandler(.success(data))
        }
    }
}

enum LoginValidationError: Error {
    case urlError
    case responseError
    case noneCase
}

enum SocialType: String, CaseIterable {
    case kakao
    case naver
    case github
}

struct LoginEntity: Encodable {
    var id: String
    var password: String
    var passwordConfirm: String
    var email: String
    var nickName: String
    var profileImage: String?
}
