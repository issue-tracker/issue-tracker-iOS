//
//  SignInFormViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/01.
//

import UIKit
import FlexLayout
import SnapKit
import ReactorKit

class SignInFormViewController: CommonProxyViewController, View {
    typealias Reactor = SignInFormReactor
    
    var disposeBag: DisposeBag = .init()
    
    private let padding: CGFloat = 8
    
    private let _containerView = UIScrollView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입"
        let font = UIFont.preferredFont(forTextStyle: .title1)
        label.font = UIFont.boldSystemFont(ofSize: font.pointSize * 0.9)
        label.accessibilityIdentifier = "회원가입"
        return label
    }()
    
    private let idTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        let mutableString = NSMutableAttributedString(string: "아이디\n영문, 숫자를 포함한 아이디를 입력해주세요(4~12자).")
        mutableString.setAttributes([.font: UIFont.preferredFont(forTextStyle: .headline)], range: NSRange(0...2))
        mutableString.setAttributes([.font: UIFont.italicSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .subheadline).pointSize)], range: NSRange(3..<mutableString.string.count))
        label.attributedText = mutableString
        return label
    }()
    private let idTextField: CommonTextField = {
        let textField = CommonTextField(frame: .zero, input: .default, placeholder: "아이디")
        textField.markerType = .none
        return textField
    }()
    private let idDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    private let passwordTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        let mutableString = NSMutableAttributedString(string: "비밀번호\n영문, 숫자를 포함한 8자 이상의 비밀번호를 입력해주세요.")
        mutableString.setAttributes([.font: UIFont.preferredFont(forTextStyle: .headline)], range: NSRange(0...3))
        mutableString.setAttributes([.font: UIFont.italicSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .subheadline).pointSize)], range: NSRange(4..<mutableString.string.count))
        label.attributedText = mutableString
        return label
    }()
    private let passwordTextField: CommonTextField = {
        let textField = CommonTextField(frame: .zero, input: .default, placeholder: "비밀번호")
        textField.markerType = .none
        return textField
    }()
    private let passwordDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    private let passwordConfirmTitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSMutableAttributedString(string: "비밀번호 확인", attributes: [.font: UIFont.preferredFont(forTextStyle: .headline)])
        return label
    }()
    private let passwordConfirmTextField: CommonTextField = {
        let textField = CommonTextField(frame: .zero, input: .default, placeholder: "비밀번호 확인")
        textField.markerType = .none
        return textField
    }()
    private let passwordConfirmDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    private let emailTitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSMutableAttributedString(string: "이메일", attributes: [.font: UIFont.preferredFont(forTextStyle: .headline)])
        return label
    }()
    private let emailTextField: CommonTextField = {
        let textField = CommonTextField(frame: .zero, input: .default, placeholder: "이메일")
        textField.markerType = .none
        return textField
    }()
    private let emailDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    private let nicknameTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        let mutableString = NSMutableAttributedString(string: "닉네임\n다른 유저와 겹치지 않는 별명을 입력해주세요.(2~12자).")
        mutableString.setAttributes([.font: UIFont.preferredFont(forTextStyle: .headline)], range: NSRange(0...2))
        mutableString.setAttributes([.font: UIFont.italicSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .subheadline).pointSize)], range: NSRange(3..<mutableString.string.count))
        label.attributedText = mutableString
        return label
    }()
    private let nicknameTextField: CommonTextField = {
        let textField = CommonTextField(frame: .zero, input: .default, placeholder: "닉네임")
        textField.markerType = .none
        return textField
    }()
    private let nicknameDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()
    
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
        
        makeSuperViewResignKeyboard()
        
        passwordTextField.isSecureTextEntry = true
        passwordConfirmTextField.isSecureTextEntry = true
        emailTextField.keyboardType = .emailAddress
        
        view.addSubview(_containerView)
        
        view.flex.define { flex in
            flex.addItem(_containerView).grow(1).paddingHorizontal(8).define { flex in
                flex.addItem(titleLabel).height(60)
                
                flex.addItem(idTitleLabel).marginBottom(8)
                flex.addItem(idTextField).height(50).marginBottom(8)
                flex.addItem(idDescriptionLabel).minHeight(12).marginBottom(16)
                
                flex.addItem(passwordTitleLabel).marginBottom(8)
                flex.addItem(passwordTextField).height(50).marginBottom(8)
                flex.addItem(passwordDescriptionLabel).minHeight(12).marginBottom(16)
                
                flex.addItem(passwordConfirmTitleLabel).marginBottom(8)
                flex.addItem(passwordConfirmTextField).height(50).marginBottom(8)
                flex.addItem(passwordConfirmDescriptionLabel).minHeight(12).marginBottom(16)
                
                flex.addItem(emailTitleLabel).marginBottom(8)
                flex.addItem(emailTextField).height(50).marginBottom(8)
                flex.addItem(emailDescriptionLabel).minHeight(12).marginBottom(16)
                
                flex.addItem(nicknameTitleLabel).marginBottom(8)
                flex.addItem(nicknameTextField).height(50).marginBottom(8)
                flex.addItem(nicknameDescriptionLabel).minHeight(12).marginBottom(16)
                
                flex.addItem(acceptButton).height(60)
            }
        }
        
        view.flex.layout()
        
        acceptButton.setCornerRadius()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        _containerView.reloadContentSizeHeight()
        _containerView.delegate = self
        
        reactor = SignInFormReactor()
    }
    
    func bind(reactor: SignInFormReactor) {
        acceptButton.rx.tap.map({Reactor.Action.requestSignIn})
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        idTextField.rx.value.orEmpty.filter({$0.count > 0}).skip(1)
            .map({Reactor.Action.checkIdTextField($0)})
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.value.orEmpty.filter({$0.count > 0}).skip(1)
            .map({Reactor.Action.checkPasswordTextField($0)})
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        passwordConfirmTextField.rx.value.orEmpty.filter({$0.count > 0}).skip(1)
            .map({Reactor.Action.checkPasswordConfirmTextField($0)})
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        emailTextField.rx.value.orEmpty.filter({$0.count > 0}).skip(1)
            .map({Reactor.Action.checkEmailTextField($0)})
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nicknameTextField.rx.value.orEmpty.filter({$0.count > 0}).skip(1)
            .map({Reactor.Action.checkNicknameTextField($0)})
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.id.$statusText)
            .do(afterNext: { [weak self] _ in self?.view.flex.layout() })
            .bind(to: idDescriptionLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.pulse(\.id.$status).map({$0.toUIColor()})
            .do(afterNext: { [weak self] _ in self?.view.flex.layout() })
            .bind(to: idDescriptionLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.password.$statusText)
            .do(afterNext: { [weak self] str in
                self?.view.flex.layout()
            })
            .bind(to: passwordDescriptionLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.pulse(\.password.$status).map({$0.toUIColor()})
            .do(afterNext: { [weak self] str in
                self?.view.flex.layout()
            })
            .bind(to: passwordDescriptionLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.password.$confirmStatusText)
            .do(afterNext: { [weak self] _ in self?.view.flex.layout() })
            .bind(to: passwordConfirmDescriptionLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.pulse(\.password.$confirmStatus).map({$0.toUIColor()})
            .do(afterNext: { [weak self] _ in self?.view.flex.layout() })
            .bind(to: passwordConfirmDescriptionLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.email.$statusText)
            .do(afterNext: { [weak self] _ in self?.view.flex.layout() })
            .bind(to: emailDescriptionLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.pulse(\.email.$status).map({$0.toUIColor()})
            .do(afterNext: { [weak self] _ in self?.view.flex.layout() })
            .bind(to: emailDescriptionLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.nickname.$statusText)
            .do(afterNext: { [weak self] _ in self?.view.flex.layout() })
            .bind(to: nicknameDescriptionLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.pulse(\.nickname.$status).map({$0.toUIColor()})
            .do(afterNext: { [weak self] _ in self?.view.flex.layout() })
            .bind(to: nicknameDescriptionLabel.rx.textColor)
            .disposed(by: disposeBag)
    }
}

extension SignInFormViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
            for item in scrollView.subviews {
                if item.isFirstResponder {
                    item.resignFirstResponder()
                }
            }
        }
    }
}

extension SignInFormReactor.TextFieldStatus {
    func toUIColor() -> UIColor {
        switch self {
        case .warning: return UIColor.systemYellow.withAlphaComponent(0.8)
        case .error: return UIColor.systemRed.withAlphaComponent(0.8)
        case .fine: return UIColor.systemGreen.withAlphaComponent(0.8)
        case .none: return UIColor.label.withAlphaComponent(0.8)
        }
    }
}
