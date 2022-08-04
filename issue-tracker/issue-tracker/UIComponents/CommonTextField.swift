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
        guard self != .none else {
            return nil
        }
        
        return UIImage(systemName: self.rawValue)
    }
}

class CommonTextField: UITextField, ViewBindable {
    
    private lazy var subBackgroundView = UIView(frame: bounds.insetBy(dx: 4, dy: 4))
    private var nextField: CommonTextField?
    var binding: ViewBinding?
    
    private let leftButton = UIButton()
    var markerType: CommonTextMarkerType = .none {
        didSet {
            isSecureTextEntry = markerType == .lock
            leftButton.setImage(markerType.getMarkerImage(), for: .normal)
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
    
    private lazy var underneathKeyboard: (CGRect) -> Bool = { [weak self] keyboardRect in
        guard let self = self, let topMostView = self.topMostView else {
            return false
        }
        
        var textFieldPosition: CGPoint = self.frame.origin
        
        if let scrollView = topMostView.subviews.first(where: { $0 is UIScrollView}) as? UIScrollView { // ScrollView에 포함된 경우
            textFieldPosition = scrollView.absolutePosition(of: self)
        }
        
        return (textFieldPosition.y + self.frame.height + 20) > keyboardRect.minY // 현재 사용자가 보는 화면의 텍스트필드 맨 아래쪽이 화면을 가리는지 확인.
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
                let keyboardRect = notification.userInfo?[UITextField.keyboardFrameEndUserInfoKey] as? CGRect,
                self.underneathKeyboard(keyboardRect)
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
            guard
                self.isFirstResponder,
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
    
    func toRequestType(urlString: String) -> RequestTextField {
        let textField = RequestTextField(frame: frame, input: keyboardType, placeholder: placeholder, markerType: markerType)
        textField.requestURLString = urlString
        return textField
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

