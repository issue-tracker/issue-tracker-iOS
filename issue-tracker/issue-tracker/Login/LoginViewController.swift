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
  
  // MARK: - Local Properties
  private var loginModel = LoginRequestHTTPModel(
    URL.apiURL ?? URL(string: ""))
  
  private var disposeBag = DisposeBag()
  private let padding: CGFloat = 8
  
  // MARK: - UI Elements
  private let infoFlexContainer = UIView()
  
  private lazy var idTextField = CommonTextField(frame: CGRect.zero,
                                                 input: .default,
                                                 placeholder: I18N.L_N_LVC_TXTF_ID,
                                                 markerType: .person)
  private lazy var passwordTextField = CommonTextField(frame: CGRect.zero,
                                                       input: .default,
                                                       placeholder: I18N.L_N_LVC_TXTF_PW,
                                                       markerType: .lock)
  
  private var loginButton: UIButton = {
    
    let button = UIButton()
    button.backgroundColor = UIColor(named: "login_button_color")
    button.setTitle(I18N.L_N_LVC_BTN_LOGIN, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: button.titleLabel?.font.pointSize ?? 16)
    button.accessibilityIdentifier = I18N.L_N_LVC_BTN_LOGIN
    return button
  }()
  
  private lazy var editUserInformationButtons = HorizontalButtons(
    identifierAccessibility: "editUserInformationButtons"
  ) {
    
    HorizontalButtonsComponents(title: I18N.L_N_LVC_BTN_PWRESET,
                                handler: UIAction(handler: { _ in
      
      self.present(UIAlertController.messageDeveloping, animated: true)
    }))
    
    HorizontalButtonsComponents(title: I18N.L_N_LVC_BTN_SIGNIN,
                                handler: UIAction(handler: { _ in
      
      self.navigationController?.pushViewController(SignInFormViewController(), animated: true)
    }))
    
    HorizontalButtonsComponents(title: I18N.L_N_LVC_BTN_SIGNIN_OAUTH,
                                handler: UIAction(handler: { _ in
      
      self.present(UIAlertController.messageDeveloping, animated: true)
    }))
  }
  
  private var signInNotifyLabel: UILabel = {
    
    let label = UILabel()
    label.text = I18N.L_N_LVC_LB_SIGN_OAUTH
    label.textColor = .secondaryLabel
    label.textAlignment = .center
    label.font = label.font.withSize(label.font.pointSize * 1.2)
    label.accessibilityIdentifier = I18N.L_N_LVC_LB_SIGN_OAUTH
    return label
  }()
  
  private lazy var signInButtons = HorizontalButtons(
    identifierAccessibility: "signInButtons"
  ) {
    HorizontalButtonsComponents(imageName: "login_octocat",
                                handler: UIAction(handler: { _ in
      
      self.present(UIAlertController.messageDeveloping, animated: true)
    }))
    
    HorizontalButtonsComponents(imageName: "login_icon_kakao",
                                handler: UIAction(handler: { _ in
      
      self.present(UIAlertController.messageDeveloping, animated: true)
    }))
    
    HorizontalButtonsComponents(imageName: "login_icon_naver",
                                handler: UIAction(handler: { _ in
      
      self.present(UIAlertController.messageDeveloping, animated: true)
    }))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    switchScreen(type: .main)
    view.addSubview(infoFlexContainer)
    
    passwordTextField.isSecureTextEntry = true
    
    loginButton.clipsToBounds = true
    
    loginButton.rx.tap.bind { [weak self] _ in
      
      guard let disposeBag = self?.disposeBag else { return }
      
      let idInput = self?.idTextField.text
      let passwordInput = self?.passwordTextField.text
      
      self?.loginModel?
        .requestLogin(id: idInput, password: passwordInput)
        .subscribe(
          onSuccess: { [weak self] loginResponse in
            
            loginResponse.setUserDefaults()
            self?.switchScreen(type: .main)
            
          },
          onFailure: { [weak self] error in
            
            let error = error as? ErrorResponseBody
            let errorMessage = error?.getErrorMessage()
            
            self?.commonAlert(
              errorMessage ?? LoginRequestHTTPModel.defaultErrorMessage
            )
          })
        .disposed(by: disposeBag)
    }
    .disposed(by: disposeBag)
    
    editUserInformationButtons.subButtons
      .forEach { button in
        
        if let font = button.titleLabel?.font {
          button.titleLabel?.font = font.withSize(font.pointSize * 0.7)
        }
      }
    
    infoFlexContainer.snp
      .makeConstraints { make in
        
        make.verticalEdges
          .equalToSuperview()
        make.horizontalEdges
          .equalTo(self.view.safeAreaLayoutGuide)
      }
    
    infoFlexContainer.flex
      .paddingHorizontal(padding)
      .justifyContent(.end)
      .define { flex in
        
        flex.addItem(idTextField) // Flex idTextField
          .height(60)
          .marginBottom(padding)
        flex.addItem(passwordTextField) // Flex idTextField
          .height(60)
          .marginBottom(padding)
        flex.addItem(loginButton) // Flex idTextField
          .height(60)
          .marginBottom(padding*3)
        flex.addItem(editUserInformationButtons) // Flex idTextField
          .height(20)
          .marginBottom(padding*5)
        flex.addItem(signInNotifyLabel) // Flex idTextField
          .alignContent(.center)
          .height(20)
          .marginBottom(padding*2)
        flex.addItem(signInButtons) // Flex idTextField
          .justifyContent(.center)
          .height(60)
          .marginBottom(padding*4)
        
        signInButtons.subButtons
          .forEach { button in
            
            button.flex.aspectRatio(1)
          }
      }
    
    view.layoutIfNeeded()
    
    infoFlexContainer.flex.layout()
    testAlreadyLogin()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    makeSuperViewResignKeyboard()
    
    loginButton.setCornerRadius()
  }
  
  private func testAlreadyLogin() {
    guard let memberId = UserDefaults.standard.value(forKey: "memberId") as? Int else {
      DispatchQueue.main.async { self.view.dismissLoadingView() }
      return
    }
    
    view.popLoadingView(type: .veryLarge)
    
    loginModel?.loginTest()
      .do(
        onSubscribe: { [weak self] in
          self?.view.dismissLoadingView()
        }
      )
      .subscribe(
        onSuccess: { [weak self] resultId in
          
          if resultId == memberId {
            self?.switchScreen(type: .main)
          } else {
            self?.commonAlert(I18N.L_N_LVC_ALERT_AUTOLOGINFAIL)
          }
          
        },
        onFailure: { [weak self] error in
          
          let error = error as? ErrorResponseBody
          let message = error?.getErrorMessage()
          
          self?.commonAlert(
            message ?? I18N.L_N_LVC_ALERT_AUTOLOGINFAIL
          )
        }
      )
      .disposed(by: disposeBag)
  }
}
