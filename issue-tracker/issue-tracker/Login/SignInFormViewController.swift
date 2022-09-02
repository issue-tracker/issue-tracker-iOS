//
//  SignInFormViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/01.
//

import UIKit
import FlexLayout
import SnapKit

class SignInFormViewController: CommonProxyViewController {
    
    private let padding: CGFloat = 8
    
    private let _containerView = UIScrollView()
    private var requestModel: RequestHTTPModel?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입"
        let font = UIFont.preferredFont(forTextStyle: .title1)
        label.font = UIFont.boldSystemFont(ofSize: font.pointSize * 0.9)
        label.accessibilityIdentifier = "회원가입"
        return label
    }()
    
    var commonTextFieldStatus: [HTTPResultStatus] {
        [
            idArea.descriptionLabel?.descriptionType,
            passwordArea.descriptionLabel?.descriptionType,
            emailArea.descriptionLabel?.descriptionType,
            nicknameArea.descriptionLabel?.descriptionType
        ].compactMap({$0})
    }
    
    private let idArea = CommonTextFieldArea(identifierAccessibility: "idArea") {
        CommonTextFieldComponents(key: "signInId", title: "아이디", subTitle: "영문, 숫자를 포함한 아이디를 입력해주세요(4~12자).", placeHolderString: "아이디")
            .toRequestType(URL.membersApiURL?.appendingPathComponent("signin-id"), optionalTrailingPath: "exists")
            .setValidateStringCount(4)
    }
    private let passwordArea = CommonTextFieldArea(identifierAccessibility: "passwordArea") {
        CommonTextFieldComponents(key: "password", title: "비밀번호", subTitle: "영문, 숫자를 포함한 8자 이상의 비밀번호를 입력해주세요.", placeHolderString: "비밀번호")
            .toCommonValidationType { textField in
                return ((textField.text?.count ?? 0) >= 8)
            } completionHandler: { label, isAcceptable in
                
                label.descriptionType = isAcceptable ? .acceptable : .error
                label.text = isAcceptable ? "이상이 발견되지 않았습니다." : "8자 이상 입력 부탁드립니다."
            }

    }
    private lazy var passwordConfirmedArea = CommonTextFieldArea(identifierAccessibility: "passwordConfirmedArea") {
        CommonTextFieldComponents(key: "passwordConfirmed", title: "비밀번호 확인", placeHolderString: "비밀번호 확인")
            .toCommonValidationType { textField in
                guard let originText = self.passwordArea.textField?.text, let text = textField.text else {
                    return false
                }
                
                return originText == text
            } completionHandler: { label, isAcceptable in
                
                label.descriptionType = isAcceptable ? .acceptable : .error
                label.text = isAcceptable ? "이상이 발견되지 않았습니다." : "같은 비밀번호를 입력해주시기 바랍니다."
            }
    }
    private let emailArea = CommonTextFieldArea(identifierAccessibility: "emailArea") {
        CommonTextFieldComponents(key: "email", title: "이메일", placeHolderString: "이메일")
            .toRequestType(URL.membersApiURL?.appendingPathComponent("email"), optionalTrailingPath: "exists")
            .setValidateStringCount(4)
    }
    private let nicknameArea = CommonTextFieldArea(identifierAccessibility: "nicknameArea") {
        CommonTextFieldComponents(key: "nickname", title: "닉네임", subTitle: "다른 유저와 겹치지 않는 별명을 입력해주세요.(2~12자)", placeHolderString: "닉네임")
            .toRequestType(URL.membersApiURL?.appendingPathComponent("nickname"), optionalTrailingPath: "exists")
            .setValidateStringCount(2)
    }
    
    private let acceptButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "login_button_color")
        button.setTitle("가입하기", for: .normal)
        let font = UIFont.preferredFont(forTextStyle: .title2)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: font.pointSize)
        button.accessibilityIdentifier = "가입하기"
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL.apiURL {
            requestModel = RequestHTTPModel(url)
        }
        
        acceptButton.addAction(
            UIAction(handler: { _ in
                if self.commonTextFieldStatus.contains(.error) || self.requestModel == nil {
                    
                    self.present(UIAlertController.messageFailed, animated: true)
                    return
                }
                else if self.commonTextFieldStatus.contains(.warning) {
                    
                    self.present(
                        UIAlertController.willProceed("입력란의 문제가 발견되었습니다. 그래도 진행하시겠습니까?", handler: { _ in
                            self.requestLogin()
                        }),
                        animated: true
                    )
                    return
                }
                
                self.requestLogin()
            }),
            for: .touchUpInside
        )
        
        passwordArea.textField?.isSecureTextEntry = true
        passwordConfirmedArea.textField?.isSecureTextEntry = true
        emailArea.textField?.keyboardType = .emailAddress
        
        view.addSubview(_containerView)
        
        _containerView.flex.alignContent(.stretch).paddingHorizontal(padding).define { flex in
            flex.addItem(titleLabel).height(60)
            flex.addItem().define { flex in
                flex.addItem(idArea)
                flex.addItem(passwordArea)
                flex.addItem(passwordConfirmedArea)
                flex.addItem(emailArea)
                flex.addItem(nicknameArea)
            }
            
            flex.addItem(acceptButton).height(60)
        }
        
        _containerView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        _containerView.layoutIfNeeded()
        _containerView.flex.layout()
        _containerView.reloadContentSizeHeight()
        
        acceptButton.setCornerRadius()
    }
    
    func requestLogin() {
        guard
            let body = [
                "signInId": idArea.textField?.text,
                "password": passwordArea.textField?.text,
                "email": emailArea.textField?.text,
                "nickname": nicknameArea.textField?.text,
                "profileImage": ""
            ] as? [String: String]
        else {
            return
        }
        
        requestModel?.builder.setBody(body)
        requestModel?.builder.setHTTPMethod("post")
        requestModel?.request(pathArray: ["members", "new", "general"], { result, respnse in
            
            let model = HTTPResponseModel()
            
            DispatchQueue.main.async {
                guard let signInResponseData = model.getDecoded(from: result, as: SignInResponse.self) else {
                    self.commonAlert(model.getMessageResponse(from: result) ?? "에러가 발생하였습니다. 재시도 바랍니다.")
                    return
                }
                
                self.commonAlert(title: "회원가입이 완료되었습니다.", "\(signInResponseData.nickname) 환영합니다!") { _ in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        })
    }
}

struct SignInResponse: Decodable {
    var id: Int
    var email: String
    var nickname: String
    var profileImage: String
}
