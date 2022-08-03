//
//  OpaqueLoadingView.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/19.
//

import UIKit

enum LoadingViewType: Float {
    case small = 1
    case large = 2
    case veryLarge = 3
}

extension UIView {
    
    func popLoading(_ sholudTurnOn: Bool, type: LoadingViewType = .small, willAutoResign: Bool = false) {
        
        DispatchQueue.main.async { [weak self] in
            if let backgroundView = self?.subviews.first(where: {$0 is OpaqueBackgroundView}) {
                self?.dismissLoadingView(backgroundView)
            }
        }
        
        guard sholudTurnOn else {
            dismissLoadingView()
            return
        }
        
        popLoadingView(type: type, willAutoResign: willAutoResign)
    }
    
    func popLoadingView(type: LoadingViewType, willAutoResign: Bool = false) {
        
        let backgroundView = OpaqueBackgroundView(frame: CGRect(origin: .zero, size: self.frame.size))
        backgroundView.effect = UIBlurEffect(style: .regular)
        self.addSubview(backgroundView)
        
        let indicator = UIActivityIndicatorView()
        backgroundView.contentView.addSubview(indicator)
        
        let scaledValue = CGFloat(type.rawValue)
        indicator.transform = CGAffineTransform(scaleX: scaledValue, y: scaledValue)
        
        indicator.center = backgroundView.center
        indicator.startAnimating()
        
        if willAutoResign {
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                self.dismissLoadingView(backgroundView)
            }
        }
    }
    
    func dismissLoadingView() {
        DispatchQueue.main.async { [weak self] in
            self?.subviews.forEach {
                if $0 is OpaqueBackgroundView {
                    $0.removeFromSuperview()
                }
            }
        }
    }
    
    func dismissLoadingView(_ targetView: UIView) {
        (targetView as? OpaqueBackgroundView)?.removeFromSuperview()
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
