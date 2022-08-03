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
                self.layoutIfNeeded() // text가 nil일 경우는 레이아웃까지도 변경될 가능성이 있음.
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
            self.text = responseStatus.status == .none ? nil : responseStatus.message
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
