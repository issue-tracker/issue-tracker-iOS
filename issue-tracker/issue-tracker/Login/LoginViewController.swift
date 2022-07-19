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
            self.navigationController?.pushViewController(SignInCategoryViewController(), animated: true)
        }))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(infoFlexContainer)
        
        infoFlexContainer.flex.marginHorizontal(padding).define { flex in
            flex.addItem().height(65%).define { flex in
                flex.addItem().grow(1)
                flex.addItem(idTextFieldContainer)
                flex.addItem(SeparatorLineView()).marginVertical(padding)
                flex.addItem(passwordTextFieldContainer)
            }
            flex.addItem(horizontalButtons).paddingTop(padding)
        }
    }
    
    @objc func pushSignInCategoryScreen(_ sender: Any?) {
        navigationController?.pushViewController(SignInCategoryViewController(), animated: true)
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
