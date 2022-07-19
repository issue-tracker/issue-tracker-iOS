//
//  OpaqueLoadingView.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/19.
//

import UIKit

enum LoadingViewType {
    case small
    case large
    case veryLarge
}

extension UIView {
    func popLoadingView(type: LoadingViewType, willAutoResign: Bool = false) {
        let backgroundView = OpaqueBackgroundView(frame: frame)
        backgroundView.effect = UIBlurEffect(style: .regular)
        addSubview(backgroundView)
        let indicator = UIActivityIndicatorView()
        backgroundView.contentView.addSubview(indicator)
        
        switch type {
        case .small:
            indicator.transform = CGAffineTransform(scaleX: 1, y: 1)
        case .large:
            indicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        case .veryLarge:
            indicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        }
        
        indicator.center = backgroundView.center
        indicator.startAnimating()
        
        if willAutoResign {
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                self.dismissLoadingView(backgroundView)
            }
        }
    }
    
    func dismissLoadingView() {
        subviews.forEach {
            if $0 is OpaqueBackgroundView {
                $0.removeFromSuperview()
            }
        }
    }
    
    func dismissLoadingView(_ targetView: OpaqueBackgroundView) {
        targetView.removeFromSuperview()
    }
}

class OpaqueBackgroundView: UIVisualEffectView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
    }
}
