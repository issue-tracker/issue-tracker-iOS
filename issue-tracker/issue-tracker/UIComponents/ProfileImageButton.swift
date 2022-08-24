//
//  ProfileImageButton.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/18.
//

import SnapKit
import FlexLayout

/// Title 라벨을 추가하면 높이가 늘어날 수 있으므로, 오토레이아웃이나 FlexLayout의 추가 작업이 필요합니다.
class ProfileImageButton: UIView {
    
    private var httpModel: RequestHTTPModel?
    private var titleLabel: UILabel?
    private var profileImageView = UIImageView(image: UIImage(systemName: "p.square.fill"))
    private var flexContainer: Flex?
    
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
        if titleLabel == nil {
            setTitleLabel()
        }
        
        titleLabel?.text = title
    }
    
    private func setTitleLabel() {
        let label = UILabel()
        titleLabel = label
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.textAlignment = .center
        
        addSubview(label)
        flexContainer?.define { flex in
            flex.height(80%)
            flex.addItem(label).height(20%)
        }
        flex.layout()
    }
    
    private func makeUI() {
        getProfileImage()
        
        addSubview(profileImageView)
        profileImageView.tintColor = .label
        
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchSelector(_:))))
        
        flexContainer = flex.alignItems(.center).define { flex in
            flex.addItem(profileImageView).aspectRatio(1).height(100%)
        }
        
        layoutIfNeeded()
        flex.layout()
    }
    
    @objc func touchSelector(_ target: Any) {
        touchHandler?()
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
            
            guard let data = try? result.get(), let image = UIImage(data: data) else {
                return
            }
            
            self.profileImageView.image = image
            self.profileImageView.contentMode = .scaleAspectFill
            self.profileImageView.setNeedsDisplay()
        })
    }
}
