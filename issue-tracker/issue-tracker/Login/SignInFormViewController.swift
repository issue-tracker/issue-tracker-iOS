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
    
    // - ID area
    private let idTitleLabel = UILabel.titleOfTextFieldLabel("아이디\n영문, 숫자를 포함한 아이디를 입력해주세요(4~12자).", 2)
    private let idTextField = CommonTextField(frame: .zero, input: .default, placeholder: "아이디")
    private let idDescriptionLabel = UILabel.footnoteLabel()
    
    // - Password area
    private let passwordTitleLabel = UILabel.titleOfTextFieldLabel("비밀번호\n영문, 숫자를 포함한 8자 이상의 비밀번호를 입력해주세요.", 3)
    private let passwordTextField = CommonTextField(frame: .zero, input: .default, placeholder: "비밀번호")
    private let passwordDescriptionLabel = UILabel.footnoteLabel()
    
    // - Password Confirm area
    private let passwordConfirmTitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSMutableAttributedString(string: "비밀번호 확인", attributes: [.font: UIFont.preferredFont(forTextStyle: .headline)])
        return label
    }()
    private let passwordConfirmTextField = CommonTextField(frame: .zero, input: .default, placeholder: "비밀번호 확인")
    private let passwordConfirmDescriptionLabel = UILabel.footnoteLabel()
    
    // - Email area
    private let emailTitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSMutableAttributedString(string: "이메일", attributes: [.font: UIFont.preferredFont(forTextStyle: .headline)])
        return label
    }()
    private let emailTextField = CommonTextField(frame: .zero, input: .default, placeholder: "이메일")
    private let emailDescriptionLabel = UILabel.footnoteLabel()
    
    // - Nickname area
    private let nicknameTitleLabel: UILabel = UILabel.titleOfTextFieldLabel("닉네임\n다른 유저와 겹치지 않는 별명을 입력해주세요.(2~12자).", 2)
    private let nicknameTextField = CommonTextField(frame: .zero, input: .default, placeholder: "닉네임")
    private let nicknameDescriptionLabel = UILabel.footnoteLabel()
    
    private var allDescriptionLabels: [UILabel] {
        [idDescriptionLabel, passwordDescriptionLabel, passwordConfirmDescriptionLabel, emailDescriptionLabel, nicknameDescriptionLabel]
    }
    private var allTextFields: [CommonTextField] {
        [idTextField, passwordTextField, passwordConfirmTextField, emailTextField, nicknameTextField]
    }
    
    private let acceptButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "login_button_color")
        button.setTitle("가입하기", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .title2).pointSize)
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
            flex.addItem(_containerView).grow(1).paddingHorizontal(padding).define { flex in
                flex.addItem(titleLabel).height(60)
                
                flex.addItem(idTitleLabel).marginBottom(padding)
                flex.addItem(idTextField).height(50).marginBottom(padding)
                flex.addItem(idDescriptionLabel).minHeight(12).marginBottom(padding*2)
                
                flex.addItem(passwordTitleLabel).marginBottom(padding)
                flex.addItem(passwordTextField).height(50).marginBottom(padding)
                flex.addItem(passwordDescriptionLabel).minHeight(12).marginBottom(padding*2)
                
                flex.addItem(passwordConfirmTitleLabel).marginBottom(padding)
                flex.addItem(passwordConfirmTextField).height(50).marginBottom(padding)
                flex.addItem(passwordConfirmDescriptionLabel).minHeight(12).marginBottom(padding*2)
                
                flex.addItem(emailTitleLabel).marginBottom(padding)
                flex.addItem(emailTextField).height(50).marginBottom(padding)
                flex.addItem(emailDescriptionLabel).minHeight(12).marginBottom(padding*2)
                
                flex.addItem(nicknameTitleLabel).marginBottom(padding)
                flex.addItem(nicknameTextField).height(50).marginBottom(padding)
                flex.addItem(nicknameDescriptionLabel).minHeight(12).marginBottom(padding*2)
                
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
            .do(onNext:{ [weak self] _ in self?.idDescriptionLabel.popLoadingView(type: .small, willAutoResign: true) })
            .debounce(.seconds(2), scheduler: ConcurrentMainScheduler.instance)
            .map({Reactor.Action.checkIdTextField($0)})
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.value.orEmpty.filter({$0.count > 0}).skip(1)
            .do(onNext:{ [weak self] _ in self?.passwordDescriptionLabel.popLoadingView(type: .small, willAutoResign: true) })
            .map({Reactor.Action.checkPasswordTextField($0)})
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        passwordConfirmTextField.rx.value.orEmpty.skip(1)
            .do(onNext:{ [weak self] _ in self?.passwordConfirmDescriptionLabel.popLoadingView(type: .small, willAutoResign: true) })
            .map({Reactor.Action.checkPasswordConfirmTextField($0)})
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        emailTextField.rx.value.orEmpty.filter({$0.count > 0}).skip(1)
            .do(onNext:{ [weak self] _ in self?.emailDescriptionLabel.popLoadingView(type: .small, willAutoResign: true) })
            .debounce(.seconds(2), scheduler: ConcurrentMainScheduler.instance)
            .map({Reactor.Action.checkEmailTextField($0)})
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nicknameTextField.rx.value.orEmpty.filter({$0.count > 0}).skip(1)
            .do(onNext:{ [weak self] _ in self?.nicknameDescriptionLabel.popLoadingView(type: .small, willAutoResign: true) })
            .debounce(.seconds(2), scheduler: ConcurrentMainScheduler.instance)
            .map({Reactor.Action.checkNicknameTextField($0)})
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        [
            Observable.zip(reactor.pulse(\.id.$statusText), reactor.pulse(\.id.$status).map({$0.toUIColor()})),
            Observable.zip(reactor.pulse(\.password.$statusText), reactor.pulse(\.password.$status).map({$0.toUIColor()})),
            Observable.zip(reactor.pulse(\.password.$confirmStatusText), reactor.pulse(\.password.$confirmStatus).map({$0.toUIColor()})),
            Observable.zip(reactor.pulse(\.email.$statusText), reactor.pulse(\.email.$status).map({$0.toUIColor()})),
            Observable.zip(reactor.pulse(\.nickname.$statusText), reactor.pulse(\.nickname.$status).map({$0.toUIColor()}))
        ].enumerated().forEach { (index: Int, observable: Observable<(String, UIColor)>) in
            observable.observe(on: MainScheduler.instance)
                .bind(onNext: { [weak self] (text: String, color: UIColor) in
                    self?.allDescriptionLabels[index].text = text
                    self?.allDescriptionLabels[index].textColor = color
                })
                .disposed(by: disposeBag)
        }
        
        reactor.pulse(\.$signInMessage).skip(1)
            .subscribe(onNext: { [weak self] message in
                self?.commonAlert(message, handler: { [weak self] _ in
                    guard let allStatus = self?.reactor?.currentState.allStatus else { return }
                    
                    if allStatus.count == allStatus.filter({$0 == .fine}).count {
                        self?.navigationController?.popViewController(animated: true)
                    }
                })
            })
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

private extension UILabel {
    static var footnoteLabel: () -> UILabel = {
        let label = UILabel(); label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }
    
    static var titleOfTextFieldLabel: (String, Int) -> UILabel = { str, separateIndex in
        let label = UILabel()
        label.numberOfLines = 2
        let mutableString = NSMutableAttributedString(string: str)
        mutableString.setAttributes([.font: UIFont.preferredFont(forTextStyle: .headline)], range: NSRange(0...separateIndex))
        mutableString.setAttributes([.font: UIFont.italicSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .subheadline).pointSize)], range: NSRange((separateIndex+1)..<mutableString.string.count))
        label.attributedText = mutableString
        return label
    }
}
