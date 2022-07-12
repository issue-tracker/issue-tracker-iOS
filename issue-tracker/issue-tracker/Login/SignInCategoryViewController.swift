//
//  SignInCategoryViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/12.
//

import UIKit
import SnapKit
import FlexLayout

class SignInCategoryViewController: UIViewController {
    
    private let loginButtonContainer = UIView()
    
    private let naverLoginButton = SingInLoginButton(loginType: .naver)
    private let kakaoLoginButton = SingInLoginButton(loginType: .kakao)
    private let githubLoginButton = SingInLoginButton(loginType: .github)
    private let defaultLoginButton = SingInLoginButton(loginType: .normal("일반회원가입"))
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "맨 아래의 '일반가입' 버튼을 제외한 버튼들을 이용해 간편가입을 이용해보세요!\n\n이미 가입한 정보들을 활용해 빠르게 회원가입을 진행하실 수 있습니다."
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let padding: CGFloat = 8
    
    private lazy var action = UIAction { _ in
        self.navigationController?.pushViewController(SignInViewController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = nil
        view.backgroundColor = .systemBackground
        view.addSubview(descriptionLabel)
        view.addSubview(loginButtonContainer)
        
        loginButtonContainer.flex.direction(.column).margin(padding).define { flex in
            flex.addItem(naverLoginButton).margin(padding).height(22%)
            flex.addItem(kakaoLoginButton).margin(padding).height(22%)
            flex.addItem(githubLoginButton).margin(padding).height(22%)
            flex.addItem(defaultLoginButton).margin(padding).height(22%)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        descriptionLabel.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.greaterThanOrEqualTo(150)
        }
        
        loginButtonContainer.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(padding)
            $0.horizontalEdges.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        view.setNeedsDisplay()
        view.layoutIfNeeded()
        
        loginButtonContainer.flex.layout()
    }
}

class SingInLoginButton: UIButton {
    convenience init(loginType: LoginType?) {
        self.init(type: .custom)
        
        imageView?.contentMode = .scaleAspectFit
        layer.cornerRadius = 3.0
        
        switch loginType {
        case .naver:
            setBackgroundImage(UIImage(named: "login_category_naver"), for: .normal)
        case .kakao:
            setBackgroundImage(UIImage(named: "login_category_kakao"), for: .normal)
        case .github:
            setBackgroundImage(UIImage(named: "login_category_github"), for: .normal)
        case .normal(let title):
            setTitle(title, for: .normal)
            setTitleColor(.label, for: .normal)
            backgroundColor = UIColor.systemGray5
            layer.borderWidth = 2
            layer.borderColor = UIColor.gray.cgColor
            layer.shadowRadius = 1
            layer.shadowOffset = frame.offsetBy(dx: 0, dy: 3).size
        default:
            return
        }
    }
}

enum LoginType {
    case naver
    case kakao
    case github
    case normal(String)
}
