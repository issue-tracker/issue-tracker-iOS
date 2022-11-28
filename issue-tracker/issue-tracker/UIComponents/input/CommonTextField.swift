//
//  CommonTextField.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/25.
//

import UIKit

enum CommonTextMarkerType: String {
    case lock = "lock"
    case calendar = "calendar"
    case person = "person.wave.2.fill"
    case mail = "mail"
    case none = ""
    
    func getMarkerImage() -> UIImage? {
        UIImage(systemName: self.rawValue)
    }
}

class CommonTextField: UITextField, ViewBindable {
    
    private var nextField: CommonTextField?
    private var leftButton: UIButton?
    private var subBackgroundView: UIView {
        UIView(frame: bounds.insetBy(dx: 4, dy: 4))
    }
    var markerType: CommonTextMarkerType = .none {
        didSet {
            setMarkerType(markerType)
        }
    }
    var binding: ViewBinding?
    
    private var showNotification: NSObjectProtocol?
    private var hideNotification: NSObjectProtocol?
    
    private var topMostView: UIView? {
        SceneDelegate.shared?.topViewController?.view
    }
    
    /// keyboard 에 의해 자신이 가려질지 확인.
    private lazy var willCoveredWithKeyboard: (CGRect) -> Bool = { [weak self] keyboardRect in
        guard let self = self, let topMostView = self.topMostView else {
            return false
        }
        
        var textFieldPosition = self.frame.origin
        if let scrollView = topMostView.subviews.first(where: { $0 is UIScrollView}) as? UIScrollView { // ScrollView에 포함된 경우
            textFieldPosition = scrollView.absolutePosition(of: self)
        }
        
        return (textFieldPosition.y + self.frame.height + 20) > keyboardRect.minY // 현재 사용자가 보는 화면의 텍스트필드 맨 아래쪽이 화면을 가리는지 확인.
    }
    
    /// 자신의 크기 중 텍스트가 입력될 크기만을 반환.
    private lazy var textFieldRect: (CGRect) -> CGRect = { [weak self] in
        guard let self = self else { return .zero }
        let padding = self.frame.height / 5
        return $0.inset(by: UIEdgeInsets(
            top: padding,
            left: self.leftViewRect(forBounds: $0).maxX+padding,
            bottom: padding,
            right: 0)
        )
    }
    
    /// 텍스트가 입력될 크기 중 우측의 Clear 버튼 크기를 제외한 폭.
    private lazy var textFieldRectExceptClearButton: (CGRect) -> CGRect = { [weak self] in
        guard let self = self else { return .zero }
        
        var textFieldRect = self.textFieldRect($0)
        guard textFieldRect != .zero else {
            return .zero
        }
        let padding = (self.frame.height / 5)
        textFieldRect.size.width -= self.clearButtonRect(forBounds: $0).width + padding
        return textFieldRect
    }
    
    convenience init(frame: CGRect, input type: UIKeyboardType, placeholder: String?, markerType: CommonTextMarkerType = .none) {
        self.init(frame: frame)
        self.keyboardType = type
        self.markerType = markerType
        self.setMarkerType(markerType)
        
        if let placeholder = placeholder {
            self.attributedPlaceholder = NSAttributedString.blackOpaqueString(placeholder)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    private func makeUI() {
        accessibilityIdentifier = placeholder
        autocapitalizationType = .none
        
        clearButtonMode = .whileEditing
        textColor = .black
        
        backgroundColor = UIColor(named: "Common_TF_BG")
        layoutIfNeeded()
        
        setNotification()
    }
    
    private func setMarkerType(_ type: CommonTextMarkerType) {
        guard markerType != .none else { return }
        
        leftButton = UIButton()
        leftButton?.setImage(type.getMarkerImage(), for: .normal)
        leftButton?.tintColor = .black
        leftView = leftButton
        leftViewMode = .always
    }
    
    private func setNotification() {
        showNotification = NotificationCenter.default.addObserver(
            forName: UITextField.keyboardWillShowNotification,
            object: nil,
            queue: OperationQueue.main)
        { notification in
            guard self.isFirstResponder else { return }
            guard
                let topMostView = self.topMostView, topMostView.bounds.origin.y == 0,
                let keyboardRect = notification.userInfo?[UITextField.keyboardFrameEndUserInfoKey] as? CGRect,
                self.willCoveredWithKeyboard(keyboardRect)
            else {
                return
            }
            
            UIView.animate(withDuration: 0.3) {
                topMostView.bounds.origin.y += keyboardRect.height
            }
        }
        
        hideNotification = NotificationCenter.default.addObserver(
            forName: UITextField.keyboardWillHideNotification,
            object: nil,
            queue: OperationQueue.main)
        { notification in
            guard self.isFirstResponder else { return }
            guard let topMostView = self.topMostView, topMostView.bounds.origin.y != 0 else {
                return
            }
            
            UIView.animate(withDuration: 0.3) {
                topMostView.bounds.origin.y = 0
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setCornerRadius()
    }
    
    deinit {
        if let showNotification = showNotification {
            NotificationCenter.default.removeObserver(showNotification)
        }
        if let hideNotification = hideNotification {
            NotificationCenter.default.removeObserver(hideNotification)
        }
    }
}

extension CommonTextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return textFieldRect(bounds)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textFieldRectExceptClearButton(bounds)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return textFieldRectExceptClearButton(bounds)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var padding = super.leftViewRect(forBounds: bounds)
        padding.origin.x += 12
        return padding
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var padding = super.rightViewRect(forBounds: bounds)
        padding.origin.x -= frame.height/5
        return padding
    }
}

extension CommonTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if returnKeyType == .next {
            nextField?.becomeFirstResponder()
            self.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        binding?.bindableHandler?(textField.text, self)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}

