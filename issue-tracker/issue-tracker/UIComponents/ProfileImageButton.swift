//
//  ProfileImageButton.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/18.
//

import SnapKit
import FlexLayout

class ProfileImageButton: UIView {
    
    private var httpModel: RequestHTTPModel?
    private var titleLabel = UILabel()
    private var profileImageView = UIImageView(image: UIImage(systemName: "p.square.fill"))
    
    var profileImageURL: String = ""
    
    var touchHandler: (()->Void)?
    
    convenience init(urlString: String = "", title: String = "") {
        self.init(frame: CGRect.zero)
        self.profileImageURL = urlString
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    private func setProperties() {
        if let url = URL(string: profileImageURL) {
            httpModel = RequestHTTPModel(url)
        }
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    private func makeUI() {
        getProfileImage()
        
        addSubview(profileImageView)
        addSubview(titleLabel)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        
        profileImageView.tintColor = .label
        
        isUserInteractionEnabled = true
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchSelector(_:))))
        
        flex.alignItems(.center).define { flex in
            flex.addItem(profileImageView).aspectRatio(1).height(80%)
            flex.addItem(titleLabel).height(20%)
        }
        
        setLayout()
    }
    
    @objc func touchSelector(_ target: Any) {
        touchHandler?()
    }
    
    func setLayout() {
        layoutIfNeeded()
        flex.layout()
    }
    
    func getProfileImage(with url: URL) {
        let modelContainer = httpModel
        defer {
            httpModel = modelContainer
        }
        
        httpModel = RequestHTTPModel(url)
        getProfileImage()
    }
    
    private func getProfileImage() {
        httpModel?.request({ result, response in
            switch result {
            case .success(let data):
                self.profileImageView.image = UIImage(data: data)
            case .failure(let error):
                print(error)
            }
            
            self.profileImageView.contentMode = .scaleAspectFill
            self.profileImageView.setNeedsDisplay()
        })
    }
}
