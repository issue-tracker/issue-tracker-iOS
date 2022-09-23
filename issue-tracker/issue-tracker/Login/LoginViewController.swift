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
    private var requestModel = RequestHTTPModel(URL.apiURL ?? URL(string: ""))
    
    private let padding: CGFloat = 8
    
    private let infoFlexContainer = UIView()
    
    private lazy var idTextField = CommonTextField(frame: CGRect.zero, input: .default, placeholder: "아이디", markerType: .person)
    private lazy var passwordTextField = CommonTextField(frame: CGRect.zero, input: .default, placeholder: "패스워드", markerType: .lock)
    
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
//        switchScreen(type: .main)
        makeSuperViewResignKeyboard()
        view.addSubview(infoFlexContainer)
        
        passwordTextField.isSecureTextEntry = true
        
        loginButton.clipsToBounds = true
        loginButton.addAction(
            UIAction(handler: { [weak self] _ in
                guard
                    let self = self,
                    let body = ["id": self.idTextField.text, "password": self.passwordTextField.text] as? [String: String]
                else {
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
        
        testAlreadyLogin()
    }
    
    private func testAlreadyLogin() {
        guard
            let requestModel = requestModel,
            let memberId = UserDefaults.standard.value(forKey: "memberId") as? Int
        else {
            DispatchQueue.main.async { self.view.dismissLoadingView() }
            return
        }
        
        view.popLoadingView(type: .veryLarge)
        
        requestModel.builder.setURLQuery(["memberId": "\(memberId)"])
        requestModel.requestObservable(pathArray: ["auth", "test"])
            .timeout(DispatchTimeInterval.seconds(3), scheduler: ConcurrentMainScheduler.instance)
            .do(onError: { [weak self] _ in
                self?.view.dismissLoadingView()
            })
            .asSingle()
            .observe(on: MainScheduler.instance)
            .subscribe({ [weak self] event in
                guard let self = self else { return }
                
                self.view.dismissLoadingView()
                
                switch event {
                case .success(let data):
                    guard self.showErrorIfExists(data: data) == false else { return }
                    
                    if let id = HTTPResponseModel().getDecoded(from: data, as: Int.self), id == memberId {
                        self.switchScreen(type: .main)
                        return
                    }
                    
                    self.commonAlert("자동 로그인 도중 에러가 발생하였습니다.")
                        
                case .failure(let error):
                    self.commonAlert(error.localizedDescription)
                }
            })
            .disposed(by: bag)
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
