//
//  LoginViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/11.
//

import UIKit
import SnapKit
import FlexLayout
import RxSwift

class LoginViewController: CommonProxyViewController {
    
    private var bag = DisposeBag()
    private var requestModel: RequestHTTPModel?
    
    private let padding: CGFloat = 8
    
    private let infoFlexContainer = UIView()
    
    private var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "login_button_color")
        button.setTitle("아이디로 로그인", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: button.titleLabel?.font.pointSize ?? 16)
        button.accessibilityIdentifier = "아이디로 로그인"
        return button
    }()
    
    private lazy var editUserInformationButtons = HorizontalButtons(identifierAccessibility: "editUserInformationButtons") {
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
        label.accessibilityIdentifier = "간편하게 로그인/회원가입"
        return label
    }()
    
    private lazy var signInButtons = HorizontalButtons(identifierAccessibility: "signInButtons") {
        HorizontalButtonsComponents(imageName: "login_octocat", handler: UIAction(handler: { _ in
            self.present(UIAlertController.messageDeveloping, animated: true)
        }))
        HorizontalButtonsComponents(imageName: "login_icon_kakao", handler: UIAction(handler: { _ in
            self.present(UIAlertController.messageDeveloping, animated: true)
        }))
        HorizontalButtonsComponents(imageName: "login_icon_naver", handler: UIAction(handler: { _ in
            self.present(UIAlertController.messageDeveloping, animated: true)
        }))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchScreen(type: .main)
        makeSuperViewResignKeyboard()
        view.addSubview(infoFlexContainer)
        
        let idTextField = CommonTextField(frame: CGRect.zero, input: .default, placeholder: "아이디", markerType: .person)
        let passwordTextField = CommonTextField(frame: CGRect.zero, input: .default, placeholder: "패스워드", markerType: .lock)
        passwordTextField.isSecureTextEntry = true
        
        if let url = URL.apiURL {
            requestModel = RequestHTTPModel(url)
        }
        
        loginButton.clipsToBounds = true
        loginButton.addAction(
            UIAction(handler: { _ in
                guard let body = ["id": idTextField.text, "password": passwordTextField.text] as? [String: String] else {
                    return
                }
                
                self.requestModel?.builder.setBody(body)
                self.requestModel?.builder.setHTTPMethod("post")
                self.requestModel?.request(pathArray: ["members","signin"], { result, response in
                    
                    let model = HTTPResponseModel()
                    
                    guard let loginResponseData = model.getDecoded(from: result, as: LoginResponse.self) else {
                        self.commonAlert(model.getMessageResponse(from: result) ?? "로그인에 실패하였습니다.")
                        return
                    }
                    
                    UserDefaults.standard.setValue(loginResponseData.accessToken.token, forKey: "accessToken")
                    UserDefaults.standard.setValue(loginResponseData.memberResponse.profileImage, forKey: "profileImage")
                    UserDefaults.standard.setValue(loginResponseData.memberResponse.id, forKey: "memberId")
                    
                    self.switchScreen(type: .main)
                })
                
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
        
        view.popLoadingView(type: .veryLarge)
        testAlreadyLogin()
            .subscribe(onNext: { data in
                if
                    let id = data as? Int,
                    let memberId = UserDefaults.standard.value(forKey: "memberId") as? Int,
                    id == memberId
                {
                    self.switchScreen(type: .main)
                }
                
                if let message = data as? String {
                    self.commonAlert(message)
                }
            })
            .disposed(by: bag)
    }
    
    private func testAlreadyLogin() -> Observable<Any> {
        guard
            let requestModel = requestModel,
            let memberId = UserDefaults.standard.value(forKey: "memberId") as? Int,
            let token = UserDefaults.standard.value(forKey: "accessToken") as? String
        else {
            DispatchQueue.main.async { self.view.dismissLoadingView() }
            return Observable.just(false)
        }
        
        requestModel.builder.setURLQuery(["memberId": "\(memberId)"])
        requestModel.builder.setHeader(key: "Authorization", value: "Bearer " + token)
        return requestModel
            .requestObservable(pathArray: ["auth", "test"])
            .map({ [weak self] data -> Any in
                
                DispatchQueue.main.async {
                    self?.view.dismissLoadingView()
                }
                
                let model = HTTPResponseModel()
                
                if let message = model.getDecoded(from: data, as: String.self) {
                    return message
                } else if let message = model.getMessageResponse(from: data) {
                    return message
                }
                
                if let id = model.getDecoded(from: data, as: Int.self) {
                    return id
                }
                
                return false
            })
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
