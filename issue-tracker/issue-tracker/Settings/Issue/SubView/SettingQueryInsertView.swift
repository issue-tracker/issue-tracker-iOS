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
class SettingQueryInsertView: CommonProxyViewController {
    
    private var addQuerySubject: PublishRelay<SettingIssueQueryItem>?
    
    private let parser = QueryParser()
    @QueryStatus private var queryStatus: QueryStatusColor = .deActiveColor {
        willSet {
            switch newValue {
            case .activeColor:
                self.deactivateButton.backgroundColor = UIColor(named: QueryStatusColor.deActiveColor.getColorName())
                self.activateButton.backgroundColor = UIColor(named: QueryStatusColor.activeColor.getColorName())
            case .deActiveColor:
                self.activateButton.backgroundColor = UIColor(named: QueryStatusColor.deActiveColor.getColorName())
                self.deactivateButton.backgroundColor = UIColor(named: QueryStatusColor.activeColor.getColorName())
            }
        }
    }
    
    private let textField = CommonTextField(frame: .zero, input: .default, placeholder: "입력")
    private lazy var activateButton: UIButton = {
        let button = UIButton()
        button.setTitle("활성화", for: .normal)
        button.backgroundColor = UIColor(named: QueryStatusColor.deActiveColor.getColorName())
        return button
    }()
    private let deactivateButton: UIButton = {
        let button = UIButton()
        button.setTitle("비활성화", for: .normal)
        button.backgroundColor = UIColor(named: QueryStatusColor.activeColor.getColorName())
        return button
    }()
    
    convenience init(_ complectionSubject: PublishRelay<SettingIssueQueryItem>?) {
        self.init()
        self.addQuerySubject = complectionSubject
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        activateButton.addAction(UIAction(handler: { [weak self] _ in self?.queryStatus = .activeColor }), for: .touchUpInside)
        deactivateButton.addAction(UIAction(handler: { [weak self] _ in self?.queryStatus = .deActiveColor }), for: .touchUpInside)
        
        view.flex.define { flex in
            flex.addItem().height(20%)
            flex.addItem(textField).height(80).margin(8)
            flex.addItem().direction(.row).justifyContent(.spaceBetween).height(60).paddingHorizontal(8).define { flex in
                flex.addItem(activateButton).grow(0.5).marginRight(8)
                flex.addItem(deactivateButton).grow(0.5)
            }
            flex.addItem().grow(1)
        }
        
        view.flex.layout()
        
        makeSuperViewResignKeyboard()
        
        textField.setShadow()
        activateButton.setCornerRadius()
        activateButton.setShadow()
        deactivateButton.setCornerRadius()
        deactivateButton.setShadow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let querySentence = textField.text, querySentence.isEmpty == false else {
            return
        }
        
        let query = String(describing: Bookmark(queryCondition: .isCondition, querySentence: querySentence))
        let item = SettingIssueQueryItem(id: UUID(), query: query, isOn: queryStatus == .activeColor, index: 0)
        addQuerySubject?.accept(item)
    }
}

@propertyWrapper struct QueryStatus {
    private var _status: QueryStatusColor = .deActiveColor
    
    var wrappedValue: QueryStatusColor {
        get { _status }
        set {
            if _status != newValue { _status = newValue }
        }
    }
    
    init(wrappedValue status: QueryStatusColor) {
        self.wrappedValue = status
    }
}
