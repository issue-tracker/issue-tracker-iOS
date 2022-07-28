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
    
    private let idTextFieldContainer = HorizontalTitleTextField {
        return HorizontalTitleTextFieldComponents(title: "ID")
    }
    private let passwordTextFieldContainer = HorizontalTitleTextField {
        return HorizontalTitleTextFieldComponents(title: "Password")
    }
    
    private lazy var horizontalButtons = HorizontalButtons {
        HorizontalButtonsComponents(title: "회원가입", handler: UIAction(handler: { _ in
            self.navigationController?.pushViewController(SignInCategoryViewController(), animated: true)
        }))
        HorizontalButtonsComponents(title: "로그인", handler: UIAction(handler: { _ in
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.switchScreen(type: .main)
        }))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignKeyboard)))
        
        view.backgroundColor = .systemBackground
        view.addSubview(infoFlexContainer)
        view.addSubview(CommonTextField(frame: CGRect(origin: CGPoint(x: 20, y: 700), size: CGSize(width: view.frame.width-20, height: 60))))
        infoFlexContainer.flex.marginHorizontal(padding).justifyContent(.end).define { flex in
            flex.addItem().define { flex in
                flex.addItem().grow(1)
                flex.addItem(idTextFieldContainer)
                flex.addItem(SeparatorLineView()).marginVertical(padding)
                flex.addItem(passwordTextFieldContainer)
            }
            flex.addItem(horizontalButtons).paddingTop(padding)
            flex.addItem().height(30%)
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
