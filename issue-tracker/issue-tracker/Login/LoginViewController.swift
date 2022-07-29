//
//  LoginViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/11.
//

import UIKit
import SnapKit
import FlexLayout

class LoginViewController: CommonProxyViewController {
    
    private let padding: CGFloat = 8
    
    private let infoFlexContainer = UIView()
    
    private var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "login_button_color")
        button.setTitle("아이디로 로그인", for: .normal)
        return button
    }()
    
    private lazy var editUserInformationButtons = HorizontalButtons {
        HorizontalButtonsComponents(title: "비밀번호 재설정", handler: UIAction(handler: { _ in
            self.navigationController?.pushViewController(SignInCategoryViewController(), animated: true)
        }))
        HorizontalButtonsComponents(title: "   ")
        HorizontalButtonsComponents(title: "회원가입", handler: UIAction(handler: { _ in
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.switchScreen(type: .main)
        }))
    }
    
    private var signInNotifyLabel: UILabel = {
        let label = UILabel()
        label.text = "간편하게 로그인/회원가입"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = label.font.withSize(label.font.pointSize * 1.2)
        return label
    }()
    
    private lazy var signInButtons = HorizontalButtons {
        HorizontalButtonsComponents(imageName: "login_octocat", handler: UIAction(handler: { _ in
            print("Hello GitHub")
        }))
        HorizontalButtonsComponents(imageName: "login_icon_kakao", handler: UIAction(handler: { _ in
            print("Hello Kakao")
        }))
        HorizontalButtonsComponents(imageName: "login_icon_naver", handler: UIAction(handler: { _ in
            print("Hello Naver")
        }))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignKeyboard)))
        
        view.backgroundColor = .systemBackground
        view.addSubview(infoFlexContainer)
        
        let idTextField = CommonTextField(frame: CGRect.zero, input: .default, placeholder: "아이디", markerType: .person)
        let passwordTextField = CommonTextField(frame: CGRect.zero, input: .default, placeholder: "패스워드", markerType: .lock)
        loginButton.layer.cornerRadius = 4
        loginButton.clipsToBounds = true
        
        editUserInformationButtons.subButtons.forEach { button in
            if let font = button.titleLabel?.font {
                button.titleLabel?.font = font.withSize(font.pointSize * 0.7)
            }
        }
        
        infoFlexContainer.flex.justifyContent(.end).define { flex in
            flex.addItem(idTextField)
                .height(60).marginBottom(padding)
            flex.addItem(passwordTextField)
                .height(60).marginBottom(padding)
            flex.addItem(loginButton)
                .height(60).marginBottom(padding)
            flex.addItem(editUserInformationButtons).justifyContent(.center)
                .height(20).marginBottom(padding*4)
            flex.addItem(signInNotifyLabel).alignContent(.center)
                .height(20).marginBottom(padding*2)
            flex.addItem(signInButtons).justifyContent(.center)
                .height(60).marginBottom(padding*4)
            signInButtons.subButtons.forEach { button in
                button.flex.aspectRatio(1)
            }
        }
        
        infoFlexContainer.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        view.layoutIfNeeded()
        
        infoFlexContainer.flex.layout()
    }
    
    @objc func pushSignInCategoryScreen(_ sender: Any?) {
        navigationController?.pushViewController(SignInCategoryViewController(), animated: true)
    }
    
    @objc func resignKeyboard() {
        self.view.endEditing(true)
    }
}
