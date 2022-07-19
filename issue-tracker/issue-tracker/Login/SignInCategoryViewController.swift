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
    
    private let naverLoginButton = SignInLoginButton(loginType: .naver)
    private let kakaoLoginButton = SignInLoginButton(loginType: .kakao)
    private let githubLoginButton = SignInLoginButton(loginType: .github)
    private let defaultLoginButton = SignInLoginButton(loginType: .normal("일반 회원가입"))
    
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
        view.addSubview(loginButtonContainer)
        
        loginButtonContainer.flex.define { flex in
            
            flex.addItem().height(5%)
            flex.addItem(descriptionLabel)
            flex.addItem().grow(1)
            
            flex.addItem().height(60%).justifyContent(.spaceBetween).define { flex in
                flex.addItem(defaultLoginButton).height(23%)
                flex.addItem(SeparatorLineView()).height(1)
                flex.addItem(githubLoginButton).height(23%)
                flex.addItem(SeparatorLineView()).height(1)
                flex.addItem(kakaoLoginButton).height(23%)
                flex.addItem(SeparatorLineView()).height(1)
                flex.addItem(naverLoginButton).height(23%)
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        loginButtonContainer.snp.makeConstraints {
            $0.leading.top.equalTo(self.view.safeAreaLayoutGuide).offset(16)
            $0.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(16)
        }
        
        view.layoutIfNeeded()
        
        loginButtonContainer.flex.layout()
    }
}
