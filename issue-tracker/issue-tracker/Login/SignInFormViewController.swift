//
//  SignInFormViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/01.
//

import UIKit
import FlexLayout
import SnapKit

class SignInFormViewController: SignInFormBuilder {
    
    private let padding: CGFloat = 8
    
    private let _containerView = UIScrollView()
    private var requestModel: RequestHTTPModel?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입"
        let font = UIFont.preferredFont(forTextStyle: .title1)
        label.font = UIFont.boldSystemFont(ofSize: font.pointSize * 0.9)
        return label
    }()
    
    private let acceptButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "login_button_color")
        button.setTitle("가입하기", for: .normal)
        let font = UIFont.preferredFont(forTextStyle: .title2)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: font.pointSize)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL.apiURL {
            requestModel = RequestHTTPModel(url)
        }
        
        acceptButton.addAction(
            UIAction(handler: { [weak self] action in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    var isInError = false
                    
                    self.view.subviews.compactMap({ $0 as? DescriptionLabel }).forEach { descLabel in
                        if descLabel.descriptionType == .error, isInError == false {
                            isInError = descLabel.descriptionType == .error
                        }
                    }
                    
                    if isInError {
                        self.present(UIAlertController.messageFailed, animated: true)
                        return
                    }
                    
                    let allTexts = self.getAllTextFieldValues()
                    
                    guard let id = allTexts["signInId"], let password = allTexts["password"], let email = allTexts["email"], let nickname = allTexts["nickname"] else {
                        return
                    }
                    
                    self.requestModel?.builder.setBody(SignInParameter(signInId: id, password: password, email: email, nickname: nickname, profileImage: ""))
                    self.requestModel?.builder.setHTTPMethod("post")
                    self.requestModel?.request(pathArray: ["members", "new", "general"], { result, respnse in
                        switch result {
                        case .success(let data):
                            let responseModel = HTTPResponseModel()
                            guard let data = responseModel.getDecoded(from: data, as: SignInResponse.self) else {
                                let errorMessage = responseModel.getMessageResponse(from: data) ?? "에러가 발생하였습니다. 재시도 바랍니다."
                                self.commonAlert(errorMessage)
                                
                                return
                            }
                            
                            self.commonAlert(title: "회원가입이 완료되었습니다.", "\(data.nickname) 환영합니다!") { _ in
                                self.navigationController?.popViewController(animated: true)
                            }
                        case .failure(let error):
                            print(error)
                        }
                    })
                }
            }),
            for: .touchUpInside
        )
        
        let idArea = getCommonTextFieldArea(key: "signInId", title: "아이디", subTitle: "영문, 숫자를 포함한 아이디를 입력해주세요.(4~12자)", placeHolderString: "아이디", urlPath: "signin-id", optionalTrailingPath: "exists", description: "멋진 아이디에요!")
        let passwordArea = getCommonTextFieldArea(key: "password", title: "비밀번호", subTitle: "영문, 숫자를 포함한 8자 이상의 비밀번호를 입력해주세요.", placeHolderString: "비밀번호", optionalTrailingPath: "exists")
        let passwordConfirmedArea = getCommonTextFieldArea(key: "passwordConfirmed", title: "비밀번호 확인", placeHolderString: "비밀번호 확인", optionalTrailingPath: "exists")
        let emailArea = getCommonTextFieldArea(key: "email", title: "이메일", placeHolderString: "이메일", urlPath: "email", optionalTrailingPath: "exists")
        let nicknameArea = getCommonTextFieldArea(key: "nickname", title: "닉네임", subTitle: "다른 유저와 겹치지 않는 별명을 입력해주세요.(2~12자)", placeHolderString: "닉네임", urlPath: "nickname", optionalTrailingPath: "exists")
        
        commonTextFieldDict["password"]?.isSecureTextEntry = true
        commonTextFieldDict["passwordConfirmed"]?.isSecureTextEntry = true
        commonTextFieldDict["email"]?.keyboardType = .emailAddress
        
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
}

struct SignInParameter: Encodable {
    var signInId: String
    var password: String
    var email: String
    var nickname: String
    var profileImage: String
}

struct SignInResponse: Decodable {
    var id: Int
    var email: String
    var nickname: String
    var profileImage: String
}

struct MessageResponse: Decodable {
    var message: String
}
