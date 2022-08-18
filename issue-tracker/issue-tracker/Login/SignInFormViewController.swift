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
        
        let idArea = getCommonTextFieldArea(title: "아이디", subTitle: "영문, 숫자를 포함한 아이디를 입력해주세요.(4~12자)", placeHolderString: "아이디", urlPath: "login-id", description: "멋진 아이디에요!")
        let passwordArea = getCommonTextFieldArea(title: "비밀번호", subTitle: "영문, 숫자를 포함한 8자 이상의 비밀번호를 입력해주세요.", placeHolderString: "비밀번호")
        let passwordConfirmedArea = getCommonTextFieldArea(title: "비밀번호 확인", placeHolderString: "비밀번호 확인")
        let emailArea = getCommonTextFieldArea(title: "이메일", placeHolderString: "이메일", urlPath: "email")
        let nicknameArea = getCommonTextFieldArea(title: "닉네임", subTitle: "다른 유저와 겹치지 않는 별명을 입력해주세요.(2~12자)", placeHolderString: "닉네임", urlPath: "nickname")
        
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
