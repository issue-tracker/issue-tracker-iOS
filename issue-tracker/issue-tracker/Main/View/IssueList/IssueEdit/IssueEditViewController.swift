//
//  IssueEditViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/21.
//

import UIKit
import RxRelay
import RxSwift
import SnapKit

enum IssueEditType {
    case add
    case update
}

class IssueEditViewController: CommonProxyViewController {

    var editType: IssueEditType = .add
    
    private var disposeBag = DisposeBag()
    private lazy var admitSaveButtonStateSubject = BehaviorRelay(value: false)
    
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
        navigationItem.title = "issue-tracker\nCreate a new issue"
        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction(handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", primaryAction: UIAction(handler: { [weak self] _ in
            // TODO: Request Save Issue
        }))
        
        admitSaveButtonStateSubject
            .subscribe(onNext: { [weak self] status in
                self?.navigationItem.rightBarButtonItem?.isEnabled = status
            })
            .disposed(by: disposeBag)
        admitSaveButtonStateSubject.accept(editType == .update)
        
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
        
    }
}
