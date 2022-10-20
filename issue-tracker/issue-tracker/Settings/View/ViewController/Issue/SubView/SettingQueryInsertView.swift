//
//  SettingQueryInsertView.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/19.
//

import FlexLayout
import RxSwift
import RxRelay
import UIKit
// QueryCondition, QueryParser
class SettingQueryInsertView: UIViewController {
    
    private var addQuerySubject: PublishRelay<SettingIssueQueryItem>?
    
    private let parser = QueryParser()
    private var queryStatus: QueryStatusColor?
    
    private let textField = CommonTextField(frame: .zero, input: .default, placeholder: "입력")
    private lazy var activateButton: UIButton = {
        let button = UIButton()
        button.setTitle("활성화", for: .normal)
        button.backgroundColor = QueryStatusColor.deActiveColor.getColor()
        return button
    }()
    private let deactivateButton: UIButton = {
        let button = UIButton()
        button.setTitle("비활성화", for: .normal)
        button.backgroundColor = QueryStatusColor.activeColor.getColor()
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
            guard self.activateButton.backgroundColor == QueryStatusColor.deActiveColor.getColor() else {
                return
            }
            
            self.deactivateButton.backgroundColor = QueryStatusColor.deActiveColor.getColor()
            self.activateButton.backgroundColor = QueryStatusColor.activeColor.getColor()
            self.queryStatus = .activeColor
        }), for: .touchUpInside)
        
        deactivateButton.addAction(UIAction(handler: { _ in
            self.deactivateButton.isEnabled = false
            defer {
                self.deactivateButton.isEnabled = true
            }
            guard self.deactivateButton.backgroundColor == QueryStatusColor.deActiveColor.getColor() else {
                return
            }
            
            self.activateButton.backgroundColor = QueryStatusColor.deActiveColor.getColor()
            self.deactivateButton.backgroundColor = QueryStatusColor.activeColor.getColor()
            self.queryStatus = .deActiveColor
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
        guard let querySentence = textField.text else { return }
        
        let query = Bookmark(queryCondition: .isCondition, querySentence: querySentence)
        let queryStatus = (self.queryStatus ?? .deActiveColor) == .activeColor
        
        addQuerySubject?.accept(SettingIssueQueryItem(id: UUID(), query: String(describing: query), isOn: queryStatus, index: 0))
    }
}
