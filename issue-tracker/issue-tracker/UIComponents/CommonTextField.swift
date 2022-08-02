//
//  CommonTextField.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/25.
//

import UIKit

enum CommonTextMarkerType {
    case lock
    case calendar
    case person
    case mail
    case none
}

class CommonTextField: UITextField {
    
    private lazy var subBackgroundView = UIView(frame: bounds.insetBy(dx: 4, dy: 4))
    private var nextField: CommonTextField?
    
    private let leftButton = UIButton()
    var markerType: CommonTextMarkerType = .none {
        didSet {
            var imageName = ""
            
            switch markerType {
            case .lock:
                imageName = "lock"
            case .calendar:
                imageName = "calendar"
            case .person:
                imageName = "person.wave.2.fill"
            case .mail:
                imageName = "mail"
            default:
                return
            }
            
            isSecureTextEntry = markerType == .lock
            leftButton.setImage(UIImage(systemName: imageName), for: .normal)
            leftButton.tintColor = .black
            leftView = leftButton
            leftViewMode = .always
        }
    }
    
    private var showNotification: NSObjectProtocol?
    private var hideNotification: NSObjectProtocol?
    
    private var sceneDelegate: SceneDelegate? {
        UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    }
    
    private var topMostView: UIView? {
        sceneDelegate?.topViewController?.view
    }
    
    private lazy var textFieldRect: (CGRect) -> CGRect = { [weak self] in
        
        guard let self = self else { return CGRect.zero }
        
        let padding = self.frame.height / 5
        return $0.inset(by: UIEdgeInsets(top: padding, left: self.leftViewRect(forBounds: $0).maxX+padding, bottom: padding, right: 0))
    }
    
    private lazy var textFieldWithClearButton: (CGRect) -> CGRect = { [weak self] in
        guard let self = self else { return .zero }
        
        var textFieldRect = self.textFieldRect($0)
        
        guard textFieldRect != .zero else { return .zero}
        
        textFieldRect.size.width -= self.clearButtonRect(forBounds: $0).width + (self.frame.height / 5)
        return textFieldRect
    }
    
    convenience init(frame: CGRect, input type: UIKeyboardType, placeholder: String?, markerType: CommonTextMarkerType = .none) {
        self.init(frame: frame)
        self.keyboardType = type
        self.markerType = markerType
        
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
        delegate = self
        
        if self.attributedPlaceholder == nil {
            self.attributedPlaceholder = NSAttributedString.blackOpaqueString("문자를 입력하세요.")
        }
        
        clearButtonMode = .whileEditing
        textColor = .black
        
        backgroundColor = UIColor(named: "Common_TF_BG")
        layoutIfNeeded()
        
        setNotification()
    }
    
    private func setNotification() {
        showNotification = NotificationCenter.default.addObserver(
            forName: UITextField.keyboardWillShowNotification,
            object: nil,
            queue: OperationQueue.main)
        { notification in
            guard
                self.isFirstResponder,
                let topMostView = self.topMostView,
                topMostView.bounds.origin.y == 0,
                let keyboardSize = notification.userInfo?[UITextField.keyboardFrameEndUserInfoKey] as? CGRect
            else {
                return
            }
            
            UIView.animate(withDuration: 0.3) {
                topMostView.bounds.origin.y += keyboardSize.height
            }
        }
        
        hideNotification = NotificationCenter.default.addObserver(
            forName: UITextField.keyboardWillHideNotification,
            object: nil,
            queue: OperationQueue.main)
        { notification in
            guard
                let topMostView = self.topMostView,
                topMostView.bounds.origin.y != 0
            else {
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
        return textFieldWithClearButton(bounds)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return textFieldWithClearButton(bounds)
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
}
