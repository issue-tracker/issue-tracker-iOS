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
import RxCocoa

class LoginViewController: CommonProxyViewController {
    
    // MARK: - OAuth Login Models start.
    private let oAuthKakao = KakaoLoginModel()
    private let oAuthNaver = NaverLoginModel()
    private let oAuthGithub = GithubLoginModel()
    // MARK: - OAuth Login Models end.
    
    private var bag = DisposeBag()
    private var loginModel = LoginRequestHTTPModel(URL.apiURL ?? URL(string: ""))
    private var disposeBag = DisposeBag()
    
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
            self.oAuthGithub?.requestLogin({ result in
                if result == false {
                    self.commonAlert()
                }
            })
        }))
        HorizontalButtonsComponents(imageName: "login_icon_kakao", handler: UIAction(handler: { _ in
            self.oAuthKakao?.requestLogin({ result in
                if result == false {
                    self.commonAlert()
                }
            })
        }))
        HorizontalButtonsComponents(imageName: "login_icon_naver", handler: UIAction(handler: { _ in
            self.oAuthNaver?.requestLogin({ result in
                if result == false {
                    self.commonAlert()
                }
            })
        }))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        switchScreen(type: .main)
        view.addSubview(infoFlexContainer)
        
        passwordTextField.isSecureTextEntry = true
        
        loginButton.clipsToBounds = true
        loginButton.rx.tap.bind { _ in
            self.loginModel?
                .requestLogin(id: self.idTextField.text, password: self.passwordTextField.text)
                .subscribe(
                    onSuccess: { [weak self] loginResponse in
                        loginResponse.setUserDefaults()
                        self?.switchScreen(type: .main)
                    },
                    onFailure: { [weak self] error in
                        guard let responseError = error as? ErrorResponseBody else {
                            self?.commonAlert(LoginRequestHTTPModel.defaultErrorMessage)
                            return
                        }
                        
                        self?.commonAlert(responseError.getErrorMessage() ?? LoginRequestHTTPModel.defaultErrorMessage)
                    })
                .disposed(by: self.disposeBag)
        }
        .disposed(by: disposeBag)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeSuperViewResignKeyboard()
    }
    
    private func testAlreadyLogin() {
        guard
            let memberId = UserDefaults.standard.value(forKey: "memberId") as? Int
        else {
            DispatchQueue.main.async { self.view.dismissLoadingView() }
            return
        }
        
        view.popLoadingView(type: .veryLarge)
        
        loginModel?.loginTest()
            .do(onSubscribe: { [weak self] in
                self?.view.dismissLoadingView()
            })
            .subscribe(onSuccess: { [weak self] resultId in
                
                guard let self = self else { return }
                
                if resultId == memberId {
                    self.switchScreen(type: .main)
                }
                
            }, onFailure: { [weak self] error in
                
                guard let error = error as? ErrorResponseBody else {
                    self?.commonAlert("자동 로그인 시도가 실패하였습니다. 재 로그인 바랍니다.")
                    return
                }
                
                self?.commonAlert(error.getErrorMessage() ?? LoginRequestHTTPModel.defaultErrorMessage)
            })
            .disposed(by: disposeBag)
    }
}
