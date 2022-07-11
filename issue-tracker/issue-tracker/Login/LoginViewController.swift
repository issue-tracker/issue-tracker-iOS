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
    
    private let idTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "ID"
        return label
    }()
    private let passwordTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "PassWord"
        return label
    }()
    
    private let idTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        return textField
    }()
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        return textField
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(infoFlexContainer)
        
        infoFlexContainer.flex.direction(.column).padding(padding).define { flex in
            
            flex.addItem().direction(.row).define { flex in
                flex.addItem(idTitleLabel).width(30%)
                flex.addItem(idTextField).width(70%)
            }
            
            flex.addItem().height(1).width(100%).marginVertical(padding).backgroundColor(.systemGray5)
            
            flex.addItem().direction(.row).define { flex in
                flex.addItem(passwordTitleLabel).width(30%)
                flex.addItem(passwordTextField).width(70%)
            }
            
            flex.addItem().direction(.row).height(30).marginTop(padding*3).marginVertical(padding).define { flex in
                flex.addItem(loginButton).grow(1)
                flex.addItem().width(10%)
                flex.addItem(signInButton).grow(1)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        infoFlexContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
            make.height.equalTo(160)
        }
        
        view.layoutIfNeeded()
        
        infoFlexContainer.flex.layout(mode: .adjustHeight)
    }
}
