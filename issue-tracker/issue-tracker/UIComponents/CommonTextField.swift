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
            
            leadingSpaceView.image = UIImage(systemName: imageName)
        }
    }
    
    private var showNotification: NSObjectProtocol?
    private var hideNotification: NSObjectProtocol?
    
    private var sceneDelegate: SceneDelegate? {
        UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    }
    
    convenience init(frame: CGRect, input type: UIKeyboardType, placeholder: String?, markerType: CommonTextMarkerType = .none) {
        self.init(frame: frame)
        self.keyboardType = type
        self.placeholder = placeholder
        self.markerType = markerType
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
        
        leadingSpaceView.frame.size = CGSize(width: frame.height, height: frame.height)
        leftView = leadingSpaceView
        leftViewMode = .always
        rightViewMode = .always
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
            let keyboardSize = notification.userInfo?[UITextField.keyboardFrameEndUserInfoKey] as? CGRect
            
            UIView.animate(withDuration: 0.3) {
                self.sceneDelegate?.topViewController?.view.bounds.origin.y += keyboardSize?.height ?? 0
//                self.frame.origin.y -= keyboardSize?.height ?? 0
            }
        }
        
        hideNotification = NotificationCenter.default.addObserver(
            forName: UITextField.keyboardWillHideNotification,
            object: nil,
            queue: OperationQueue.main)
        { notification in
            let keyboardSize = notification.userInfo?[UITextField.keyboardFrameEndUserInfoKey] as? CGRect
            UIView.animate(withDuration: 0.3) {
                self.sceneDelegate?.topViewController?.view.bounds.origin.y -= keyboardSize?.height ?? 0
//                self.frame.origin.y += keyboardSize?.height ?? 0
            }
        }
    }
    
    func setNext(textField: CommonTextField) {
        returnKeyType = .next
        nextField = textField
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 4, left: leftView?.frame.width ?? 4, bottom: 4, right: rightView?.frame.width ?? 4))
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 4, left: leftView?.frame.width ?? 4, bottom: 4, right: rightView?.frame.width ?? 4))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 4, left: leftView?.frame.width ?? 4, bottom: 4, right: rightView?.frame.width ?? 4))
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
