//
//  IssueEditViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/21.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import ReactorKit

enum IssueEditType {
    case add
    case update
}

final class IssueEditViewController: CommonProxyViewController, View {
    typealias Reactor = IssueEditReactor
    
    var editType: IssueEditType = .add
    var reloadSubject: PublishSubject<MainListType>?
    
    var disposeBag = DisposeBag()
    
    let leftCancelButton = UIBarButtonItem(systemItem:.cancel)
    let rightSubmitButton = UIBarButtonItem(title: "Submit")
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.placeholder = "Title"
        textField.accessibilityIdentifier = "issueUpdateTitle"
        return textField
    }()
    
    private lazy var contentsTextView: UITextView = {
        let textView = UITextView()
        textView.accessibilityIdentifier = "issueUpdateContents"
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.opaqueSeparator
        navigationItem.title = "Create a new issue"
        navigationItem.leftBarButtonItem = leftCancelButton
        navigationItem.rightBarButtonItem = rightSubmitButton
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        view.addSubview(titleTextField)
        view.addSubview(contentsTextView)
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(45)
        }
        
        contentsTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        reactor = IssueEditReactor()
    }

    func bind(reactor: IssueEditReactor) {
        leftCancelButton.rx.tap
            .bind(onNext: { _ in self.dismiss(animated: true) })
            .disposed(by: disposeBag)

        rightSubmitButton.rx.tap.map({ Reactor.Action.submit })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        titleTextField.rx.text.map({ Reactor.Action.titleChanged($0) }).skip(1)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$rightBarButtonState)
            .bind(to: rightSubmitButton.rx.isEnabled)
            .disposed(by: disposeBag)

        contentsTextView.rx.text.map({ Reactor.Action.contentsChanged($0) })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
