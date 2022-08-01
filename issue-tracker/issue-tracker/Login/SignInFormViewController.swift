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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.font = label.font.withSize(label.font.pointSize * 1.2)
        return label
    }()
    
    private let acceptButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "login_button_color")
        button.setTitle("가입하기", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let idArea = getCommonTextFieldArea(title: "아이디", subTitle: "영문, 숫자를 포함한 아이디를 입력해주세요.(4~12자)", placeHolderString: "아이디", description: "멋진 아이디에요!")
        let passwordArea = getCommonTextFieldArea(title: "비밀번호", subTitle: "영문, 숫자를 포함한 8자 이상의 비밀번호를 입력해주세요.", placeHolderString: "비밀번호")
        let passwordConfirmedArea = getCommonTextFieldArea(title: "비밀번호 확인", placeHolderString: "비밀번호 확인")
        let emailArea = getCommonTextFieldArea(title: "이메일", placeHolderString: "이메일")
        let nicknameArea = getCommonTextFieldArea(title: "닉네임", subTitle: "다른 유저와 겹치지 않는 별명을 입력해주세요.(2~12자)", placeHolderString: "닉네임")
        
        view.addSubview(_containerView)
        
        _containerView.flex.alignContent(.stretch).define { flex in
            flex.addItem(titleLabel).maxHeight(60)
            flex.addItem().define { flex in
                flex.addItem(idArea)
                flex.addItem(passwordArea)
                flex.addItem(passwordConfirmedArea)
                flex.addItem(emailArea)
                flex.addItem(nicknameArea)
            }
            
            flex.addItem(acceptButton).maxHeight(60)
        }
        
        _containerView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        _containerView.layoutIfNeeded()
        _containerView.flex.layout()
        _containerView.reloadContentSizeHeight()
        
        acceptButton.layer.cornerRadius = acceptButton.frame.height/4
        acceptButton.clipsToBounds = true
        acceptButton.setNeedsDisplay()
    }
    
    func getCommonTextFieldArea(title: String, subTitle: String? = nil, placeHolderString: String? = nil, description: String? = nil) -> UIView {
        let areaView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.attributedText = NSAttributedString(string: title, attributes: [.font: UIFont.preferredFont(forTextStyle: .headline, compatibleWith: nil)])
        
        let subTitleLabel = UILabel()
        subTitleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subTitleLabel.text = subTitle
        subTitleLabel.minimumScaleFactor = 0.2
        
        let commonTextField = CommonTextField(frame: .zero, input: .default, placeholder: placeHolderString)
        
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        descriptionLabel.text = description ?? " "
        descriptionLabel.minimumScaleFactor = 0.2
        
        view.addSubview(areaView)
        areaView.flex.define { flex in
            flex.addItem(titleLabel).paddingVertical(padding)
            flex.addItem(subTitleLabel).paddingBottom(padding)
            flex.addItem(commonTextField).minHeight(40).paddingBottom(padding)
            flex.addItem(descriptionLabel).paddingBottom(padding)
        }
        
        return areaView
    }
}
