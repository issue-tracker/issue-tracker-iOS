//
//  SettingQueryInsertView.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/19.
//

import FlexLayout
import RxSwift
import RxRelay
// QueryCondition, QueryParser
class SettingQueryInsertView: UIViewController {
    
    private var addQuerySubject: PublishRelay<SettingIssueQueryItem>?
    
    private let parser = QueryParser()
    
    private let textField = CommonTextField(frame: .zero, input: .default, placeholder: "입력")
    private lazy var activateButton: UIButton = {
        let button = UIButton()
        button.setTitle("활성화", for: .normal)
        button.backgroundColor = ButtonColors.deActiveColor.getColor()
        return button
    }()
    private let deactivateButton: UIButton = {
        let button = UIButton()
        button.setTitle("비활성화", for: .normal)
        button.backgroundColor = ButtonColors.activeColor.getColor()
        return button
    }()
    
    convenience init(_ complectionSubject: PublishRelay<SettingIssueQueryItem>?) {
        self.init()
        self.addQuerySubject = complectionSubject
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        activateButton.addAction(UIAction(handler: { _ in
            self.activateButton.isEnabled = false
            defer {
                self.activateButton.isEnabled = true
            }
            guard self.activateButton.backgroundColor == ButtonColors.deActiveColor.getColor() else {
                return
            }
            
            self.deactivateButton.backgroundColor = ButtonColors.deActiveColor.getColor()
            self.activateButton.backgroundColor = ButtonColors.activeColor.getColor()
        }), for: .touchUpInside)
        
        deactivateButton.addAction(UIAction(handler: { _ in
            self.deactivateButton.isEnabled = false
            defer {
                self.deactivateButton.isEnabled = true
            }
            guard self.deactivateButton.backgroundColor == ButtonColors.deActiveColor.getColor() else {
                return
            }
            
            self.activateButton.backgroundColor = ButtonColors.deActiveColor.getColor()
            self.deactivateButton.backgroundColor = ButtonColors.activeColor.getColor()
        }), for: .touchUpInside)
        
        view.flex.define { flex in
            flex.addItem().minHeight(40%).maxWidth(60%)
            flex.addItem(textField).height(80).margin(8)
            flex.addItem().direction(.row).justifyContent(.spaceBetween).height(60).paddingHorizontal(8).define { flex in
                flex.addItem(activateButton).grow(0.5).marginRight(8)
                flex.addItem(deactivateButton).grow(0.5)
            }
            flex.addItem().grow(1)
        }
        
        view.flex.layout()
        
        textField.setShadow()
        activateButton.setCornerRadius()
        activateButton.setShadow()
        deactivateButton.setCornerRadius()
        deactivateButton.setShadow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let query = Bookmark(queryCondition: .isCondition, querySentence: textField.text ?? "")
        addQuerySubject?.accept(SettingIssueQueryItem(
            id: UUID(),
            query: String(describing: query),
            isOn: self.activateButton.backgroundColor == ButtonColors.activeColor.getColor(),
            index: 0)
        )
    }
    
    enum ButtonColors {
        case activeColor
        case deActiveColor
        
        func getColor() -> UIColor {
            switch self {
            case .activeColor:
                return .green.withAlphaComponent(0.8)
            case .deActiveColor:
                return .lightGray.withAlphaComponent(0.8)
            }
        }
    }
}
