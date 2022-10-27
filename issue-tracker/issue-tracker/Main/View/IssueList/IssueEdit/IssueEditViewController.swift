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

class IssueEditViewController: CommonProxyViewController, MainListReloadable {

    var editType: IssueEditType = .add
    var reloadSubject: PublishSubject<ReloadListType>?
    
    private var disposeBag = DisposeBag()
    private lazy var admitSaveButtonStateSubject = BehaviorRelay<Bool>(value: false)
    
    let model: IssueAddRemoveModel? = {
        guard let url = URL.issueApiURL else { return nil }
        return IssueAddRemoveModel(url)
    }()
    
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction(handler: { _ in
            self.dismiss(animated: true)
        }))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", primaryAction: UIAction(handler: { _ in
            guard
                let title = self.titleTextField.text,
                let comment = self.contentsTextView.text,
                let id = UserDefaults.standard.value(forKey: "memberId") as? Int
            else {
                return
            }
            
            self.model?.addIssue(IssueAddParameter(title: title, comment: comment, assigneeIds: [id], labelIds: [1,2,3,4], milestoneId: 1))
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { entity in
                    guard entity != nil else {
                        self.commonAlert("오류가 발생했습니다!")
                        return
                    }
                    
                    self.reloadSubject?.onNext(.issue)
                    self.dismiss(animated: true)
                })
                .disposed(by: self.disposeBag)
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
        
        titleTextField.rx.text
            .bind { text in
                guard let text = text else {
                    self.admitSaveButtonStateSubject.accept(false)
                    return
                }
                
                self.admitSaveButtonStateSubject.accept(!text.isEmpty)
            }
            .disposed(by: disposeBag)
        
        contentsTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
