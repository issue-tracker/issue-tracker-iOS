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
                color = .red
            case .warning:
                color = .yellow
            case .acceptable:
                color = .green
            case .none:
                color = .clear
            }
            
            textColor = color
            setNeedsDisplay()
        }
    }
    
    func setResponseStatus(_ responseStatus: ResponseStatus?) {
        
        defer {
            layoutIfNeeded() // text가 nil일 경우는 레이아웃까지도 변경될 가능성이 있음.
        }
        
        guard let responseStatus = responseStatus else {
            text = nil
            return
        }
        
        self.descriptionType = responseStatus.status
        
        if responseStatus.status == .none {
            text = nil
        } else {
            text = responseStatus.message
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
}
