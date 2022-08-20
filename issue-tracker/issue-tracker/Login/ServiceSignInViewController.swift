//
//  ServiceSignInViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/18.
//

import SnapKit
import FlexLayout
import CoreGraphics

class ServiceSignInViewController: SignInFormBuilder {
    
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
        
        let emailArea = getCommonTextFieldArea(key: "email", title: "이메일", placeHolderString: "이메일", urlPath: "email")
        let nicknameArea = getCommonTextFieldArea(key: "nickname", title: "닉네임", subTitle: "다른 유저와 겹치지 않는 별명을 입력해주세요.(2~12자)", placeHolderString: "닉네임", urlPath: "nickname")
        
        emailArea.subviews.filter({$0 is CommonTextField}).forEach {
            ($0 as? CommonTextField)?.isUserInteractionEnabled = false
            ($0 as? CommonTextField)?.backgroundColor = .lightGray
        }
        
        view.addSubview(_containerView)
        
        _containerView.flex.alignContent(.stretch).paddingHorizontal(padding).define { flex in
            flex.addItem(titleLabel).height(60)
            flex.addItem().define { flex in
                flex.addItem(emailArea)
                flex.addItem(nicknameArea)
            }
            flex.addItem(acceptButton).height(60)
        }
        
        _containerView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaInsets)
        }
        
        _containerView.layoutIfNeeded()
        _containerView.flex.layout()
        _containerView.reloadContentSizeHeight()
        
        acceptButton.setCornerRadius()
    }
}
