//
//  SignInFormViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/01.
//

import UIKit
import FlexLayout
import SnapKit

class SignInFormViewController: CommonProxyViewController, ViewBinding {
    
    private let padding: CGFloat = 8
    
    private let _containerView = UIScrollView()
    
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
        
        let checkURL = "http://3.36.249.0:8080/api/members"
        
        let idArea = getCommonTextFieldArea(title: "아이디", subTitle: "영문, 숫자를 포함한 아이디를 입력해주세요.(4~12자)", placeHolderString: "아이디", requestURLString: "\(checkURL)/login-id/", description: "멋진 아이디에요!")
        let passwordArea = getCommonTextFieldArea(title: "비밀번호", subTitle: "영문, 숫자를 포함한 8자 이상의 비밀번호를 입력해주세요.", placeHolderString: "비밀번호")
        let passwordConfirmedArea = getCommonTextFieldArea(title: "비밀번호 확인", placeHolderString: "비밀번호 확인")
        let emailArea = getCommonTextFieldArea(title: "이메일", placeHolderString: "이메일", requestURLString: "\(checkURL)/email/")
        let nicknameArea = getCommonTextFieldArea(title: "닉네임", subTitle: "다른 유저와 겹치지 않는 별명을 입력해주세요.(2~12자)", placeHolderString: "닉네임", requestURLString: "\(checkURL)/nickname/")
        
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
    
    var bindableHandler: ((Any?, ViewBindable) -> Void)? = { param, bindable in
        guard let param = param as? [String: Any] else { return }
        
        if let descriptionLabel = bindable as? DescriptionLabel, let result = param["result"] as? ResponseStatus {
            
            descriptionLabel.popLoading(result.isRequesting)
            descriptionLabel.setResponseStatus(result)
        }
    }
    
    private func getCommonTextFieldArea(
        title: String,
        subTitle: String? = nil,
        placeHolderString: String? = nil,
        requestURLString: String? = nil,
        description: String? = nil
    ) -> UIView {
        let areaView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.attributedText = NSAttributedString(string: title, attributes: [.font: UIFont.preferredFont(forTextStyle: .headline, compatibleWith: nil)])
        
        let subTitleLabel = UILabel()
        let subTitleFont = UIFont.preferredFont(forTextStyle: .subheadline)
        subTitleLabel.font = UIFont.boldSystemFont(ofSize: subTitleFont.pointSize)
        subTitleLabel.text = subTitle
        subTitleLabel.adjustsFontSizeToFitWidth = true
        
        var commonTextField = CommonTextField(frame: .zero, input: .default, placeholder: placeHolderString)
        if let requestURLString = requestURLString {
            commonTextField = commonTextField.toRequestType(urlString: requestURLString)
        }
        commonTextField.binding = self
        
        let descriptionLabel = DescriptionLabel()
        descriptionLabel.binding = self
        let descriptionFont = UIFont.preferredFont(forTextStyle: .subheadline)
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: descriptionFont.pointSize)
        descriptionLabel.text = description ?? " "
        subTitleLabel.adjustsFontSizeToFitWidth = true
        
        (commonTextField as? RequestTextField)?.resultLabel = descriptionLabel
        
        view.addSubview(areaView)
        areaView.flex.define { flex in
            flex.addItem(titleLabel).paddingVertical(padding)
            flex.addItem(subTitleLabel).marginBottom(padding)
            flex.addItem(commonTextField).minHeight(40).marginBottom(padding)
            flex.addItem(descriptionLabel)
        }
        
        return areaView
    }
}
