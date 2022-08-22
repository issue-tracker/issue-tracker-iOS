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
    
    private var requestModel: RequestHTTPModel?
    
    private let padding: CGFloat = 8
    
    private let infoFlexContainer = UIView()
    
    private var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "login_button_color")
        button.setTitle("아이디로 로그인", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: button.titleLabel?.font.pointSize ?? 16)
        return button
    }()
    
    private lazy var editUserInformationButtons = HorizontalButtons {
        HorizontalButtonsComponents(title: "비밀번호 재설정", handler: UIAction(handler: { _ in
            self.present(UIAlertController.messageDeveloping, animated: true)
        }))
        HorizontalButtonsComponents(title: "회원가입", handler: UIAction(handler: { _ in
            self.navigationController?.pushViewController(SignInFormViewController(), animated: true)
        }))
        HorizontalButtonsComponents(title: "간편회원가입", handler: UIAction(handler: { _ in
            self.present(UIAlertController.messageDeveloping, animated: true)
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
//            guard let url = URL.githubOauthURL else { self.present(UIAlertController.messageFailed, animated: true); return; }
//            UIApplication.shared.open(url)
            self.present(UIAlertController.messageDeveloping, animated: true)
        }))
        HorizontalButtonsComponents(imageName: "login_icon_kakao", handler: UIAction(handler: { _ in
//            guard let url = URL.kakaoOauthURL else { self.present(UIAlertController.messageFailed, animated: true); return; }
//            UIApplication.shared.open(url)
            self.present(UIAlertController.messageDeveloping, animated: true)
        }))
        HorizontalButtonsComponents(imageName: "login_icon_naver", handler: UIAction(handler: { _ in
//            guard let url = URL.naverOauthURL else { self.present(UIAlertController.messageFailed, animated: true); return; }
//            UIApplication.shared.open(url)
            self.present(UIAlertController.messageDeveloping, animated: true)
        }))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(infoFlexContainer)
        
        let idTextField = CommonTextField(frame: CGRect.zero, input: .default, placeholder: "아이디", markerType: .person)
        let passwordTextField = CommonTextField(frame: CGRect.zero, input: .default, placeholder: "패스워드", markerType: .lock)
        
        if let url = URL.apiURL {
            requestModel = RequestHTTPModel(url)
        }
        
        loginButton.clipsToBounds = true
        loginButton.addAction(
            UIAction(handler: { _ in
                guard let id = idTextField.text, let password = passwordTextField.text else {
                    return
                }
                
                self.requestModel?.builder.setBody(["id":id,"password":password])
                self.requestModel?.builder.setHTTPMethod("post")
                self.requestModel?.request({ result, response in
                    switch result {
                    case .success(let data):
                        
                        let responseModel = HTTPResponseModel()
                        guard let loginData = responseModel.getDecoded(from: data, as: LoginResponse.self) else {
                            self.commonAlert(responseModel.getMessageResponse(from: data) ?? "로그인에 실패하였습니다.")
                            return
                        }
                        
                        UserDefaults.standard.setValue(loginData.accessToken.token, forKey: "accessToken")
                        self.switchScreen(type: .main)
                    case .failure(let error):
                        print(error)
                    }
                }, pathArray: ["members","signin"])
                
            }),
            for: .touchUpInside
        )
        
        editUserInformationButtons.subButtons.forEach { button in
            if let font = button.titleLabel?.font {
                button.titleLabel?.font = font.withSize(font.pointSize * 0.7)
            }
        }
        
        infoFlexContainer.flex.paddingHorizontal(padding).justifyContent(.end).define { flex in
            flex.addItem(idTextField)
                .height(60).marginBottom(padding)
            flex.addItem(passwordTextField)
                .height(60).marginBottom(padding)
            flex.addItem(loginButton)
                .height(60).marginBottom(padding*3)
            flex.addItem(editUserInformationButtons)
                .height(20).marginBottom(padding*5)
            flex.addItem(signInNotifyLabel).alignContent(.center)
                .height(20).marginBottom(padding*2)
            flex.addItem(signInButtons).justifyContent(.center)
                .height(60).marginBottom(padding*4)
            signInButtons.subButtons.forEach { button in
                button.flex.aspectRatio(1)
            }
        }
        
        infoFlexContainer.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        view.layoutIfNeeded()
        
        infoFlexContainer.flex.layout()
        
        loginButton.setCornerRadius()
    }
}

struct LoginResponse: Decodable {
    var memberResponse: MemberResponse
    var accessToken: AccessToken
}

struct MemberResponse: Decodable {
    var id: Int
    var email: String
    var nickname: String
    var profileImage: String
}

struct AccessToken: Decodable {
    var token: String
}
