//
//  LoginViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/11.
//

import UIKit
import SnapKit
import FlexLayout

class LoginViewController: UIViewController {
    
    private let padding: CGFloat = 8
    
    private let infoFlexContainer = UIView()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(UIColor.secondaryLabel, for: .normal)
        return button
    }()
    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(UIColor.secondaryLabel, for: .normal)
        return button
    }()
    
    private var idTextFieldContainer = HorizontalTitleTextField {
        return HorizontalTitleTextFieldComponents(title: "ID")
    }
    private var passwordTextFieldContainer = HorizontalTitleTextField {
        return HorizontalTitleTextFieldComponents(title: "Password")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(infoFlexContainer)
        signInButton.addTarget(self, action: #selector(pushSignInCategoryScreen(_:)), for: .touchUpInside)
        
        infoFlexContainer.flex.direction(.column).margin(padding).define { flex in
            
            flex.addItem(idTextFieldContainer).grow(1)
            
            flex.addItem().height(1).width(100%).marginVertical(padding).backgroundColor(.systemGray5)
            
            flex.addItem(passwordTextFieldContainer).grow(1)
            
            flex.addItem().direction(.row).height(30).marginTop(padding*3).marginVertical(padding).define { flex in
                flex.addItem(loginButton).grow(1)
                flex.addItem().width(10%)
                flex.addItem(signInButton).grow(1)
            }
        }
    }
    
    @objc func pushSignInCategoryScreen(_ sender: Any?) {
        navigationController?.pushViewController(SignInCategoryViewController(), animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        infoFlexContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(160)
        }
        
        view.layoutIfNeeded()
        
        infoFlexContainer.flex.layout()
    }
}
