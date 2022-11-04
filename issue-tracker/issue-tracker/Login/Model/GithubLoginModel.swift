//
//  GithubLoginModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/31.
//

import UIKit

class GithubLoginModel: RequestHTTPModel {
    
    convenience init?() {
        self.init(URL.githubOauthURL)
    }
    
    func requestLogin(_ completionHandler: @escaping ((Bool)->Void)) {
        UIApplication.shared.open(
            builder.baseURL
        ) { result in
            completionHandler(result)
        }
    }
}
