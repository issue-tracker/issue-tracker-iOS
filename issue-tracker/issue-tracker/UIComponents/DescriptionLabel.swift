//
//  DescriptionLabel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/03.
//

import UIKit

class DescriptionLabel: UILabel, ViewBindable {
    var binding: ViewBinding?
    var descriptionType: HTTPResultStatus = .none {
        didSet {
            var color: UIColor?
            switch descriptionType {
            case .error:
                color = .systemRed
            case .warning:
                color = .systemYellow
            case .acceptable:
                color = .systemGreen
            case .none:
                color = .clear
            }
            
            DispatchQueue.main.async {
                self.textColor = color
                self.setNeedsDisplay()
            }
        }
    }
    
    func setResponseStatus(_ responseStatus: ResponseStatus?) {
        
        defer {
            DispatchQueue.main.async {
                self.setNeedsDisplay() // 레이아웃을 변경하기 위해 FlexLayout의 레이아웃을 변경하지는 않으므로 Display만 명시적으로 변경.
            }
        }
        
        guard let responseStatus = responseStatus else {
            DispatchQueue.main.async {
                self.text = nil
            }
            
            return
        }
        
        self.descriptionType = responseStatus.status
        
        DispatchQueue.main.async {
            self.text = (responseStatus.status == .none) ? nil : responseStatus.message
        }
    }
}

enum HTTPResultStatus {
    case error
    case warning
    case acceptable
    case none
}

struct ResponseStatus {
    var status: HTTPResultStatus = .none
    var result: Result<Data, Error>?
    var response: URLResponse?
    var message: String = ""
    var isRequesting: Bool = true
}
