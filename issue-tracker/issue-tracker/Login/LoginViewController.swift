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
        idTextField.frame.size.height = 120
        let passwordTextField = CommonTextField(frame: CGRect.zero, input: .default, placeholder: "패스워드", markerType: .lock)
        passwordTextField.frame.size.height = 120
        loginButton.frame.size.height = 120
        loginButton.layer.cornerRadius = 4
        loginButton.clipsToBounds = true
        
        editUserInformationButtons.subButtons.forEach { button in
            if let font = button.titleLabel?.font {
                button.titleLabel?.font = font.withSize(font.pointSize * 0.7)
            }
        }
        
        infoFlexContainer.flex.marginHorizontal(padding).justifyContent(.end).define { flex in
            flex.addItem(idTextField)
            flex.addItem().height(padding)
            flex.addItem(passwordTextField)
            flex.addItem().height(padding)
            flex.addItem(loginButton)
            flex.addItem().height(padding)
            flex.addItem(editUserInformationButtons)
            flex.addItem().height(padding*4)
            flex.addItem(signInNotifyLabel).alignContent(.center)
            flex.addItem().height(padding*2)
            flex.addItem(signInButtons)
        }
        
        editUserInformationButtons.flex.justifyContent(.center)
        
        signInButtons.flex.height(120).justifyContent(.center)
        signInButtons.subButtons.forEach { button in
            button.flex.aspectRatio(1)
        }
    }
    
    @objc func pushSignInCategoryScreen(_ sender: Any?) {
        navigationController?.pushViewController(SignInCategoryViewController(), animated: true)
    }
    
    @objc func resignKeyboard() {
        self.view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        infoFlexContainer.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        view.layoutIfNeeded()
        infoFlexContainer.flex.layout()
    }
}
