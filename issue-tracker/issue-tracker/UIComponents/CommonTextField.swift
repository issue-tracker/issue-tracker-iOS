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
    
    private let leadingSpaceView = UIImageView()
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
            leadingSpaceView.image = UIImage(systemName: imageName)
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
        
        leftViewMode = .always
        leadingSpaceView.frame.size = CGSize(width: frame.height, height: frame.height)
        leftView = leadingSpaceView
        textColor = .black
        
        backgroundColor = UIColor(named: "Common_TF_BG")
        layer.cornerRadius = frame.height/4
        clipsToBounds = true
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
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let padding = frame.height / 5
        return bounds.inset(by: UIEdgeInsets(top: 4, left: padding, bottom: 4, right: padding))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let padding = frame.height / 5
        return bounds.inset(by: UIEdgeInsets(top: 4, left: padding, bottom: 4, right: padding))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let padding = frame.height / 5
        return bounds.inset(by: UIEdgeInsets(top: 4, left: padding, bottom: 4, right: padding))
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

extension CommonTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if returnKeyType == .next {
            nextField?.becomeFirstResponder()
            self.resignFirstResponder()
        }
        
        return true
    }
}
