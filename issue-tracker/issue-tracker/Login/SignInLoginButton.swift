//
//  SignInLoginButton.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/19.
//

import UIKit
import FlexLayout

class SignInLoginButton: UIButton {
    
    let symbolImageView = UIImageView()
    let nameLabel = UILabel()
    let containerView = UIView()
    
    convenience init(loginType: LoginType?) {
        self.init(type: .custom)
        
        symbolImageView.contentMode = .scaleAspectFit
        addSubview(containerView)
        
        switch loginType {
        case .naver:
            symbolImageView.image = UIImage(named: "login_icon_naver")
            nameLabel.text = "네이버 로그인"
            backgroundColor = UIColor(named: "login_naver_color")
        case .kakao:
            backgroundColor = UIColor(named: "login_kakao_color")
            symbolImageView.image = UIImage(named: "login_icon_kakao")
            nameLabel.text = "카카오 로그인"
        case .github:
            backgroundColor = UIColor(named: "login_github_color")
            symbolImageView.image = UIImage(named: "login_octocat")
            nameLabel.text = "깃허브 로그인"
        case .normal(let title):
            backgroundColor = UIColor.systemGray5
            symbolImageView.image = UIImage(systemName: "key.fill")
            nameLabel.text = title
        default:
            return
        }
        
        containerView.flex.direction(.row).margin(8).define { flex in
            flex.addItem(symbolImageView).width(27%)
            flex.addItem().width(5%).marginVertical(8)
            flex.addItem(nameLabel).width(62%)
        }
        
        layer.cornerRadius = 8.0
        layer.borderColor = UIColor.opaqueSeparator.cgColor
        layer.borderWidth = 2
        layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        containerView.frame = bounds
        containerView.flex.layout()
    }
}

enum LoginType {
    case naver
    case kakao
    case github
    case normal(String)
}
