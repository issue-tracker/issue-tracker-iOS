//
//  KakaoLoginModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/31.
//

import UIKit

class KakaoLoginModel: RequestHTTPModel {
    
    convenience init?() {
        self.init(URL.kakaoOauthURL)
    }
    
    func requestLogin(_ completionHandler: @escaping ((Bool)->Void)) {
        UIApplication.shared.open(
            builder.baseURL,
            options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly: true]
        ) { result in
            completionHandler(result)
        }
    }
}
