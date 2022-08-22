//
//  HTTPResponseModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/22.
//

import Foundation

class HTTPResponseModel {
    
    private let decoder = JSONDecoder()
    
    var response: URLResponse?
    
    convenience init(response: URLResponse?) {
        self.init()
        self.response = response
    }
    
    func getMessageResponse(from data: Data) -> String? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data) else {
            return nil
        }
        
        return (jsonObject as? [String: String])?["message"]
    }
    
    func getDecoded<T: Decodable>(from data: Data, as type: T.Type) -> T? {
        try? decoder.decode(type, from: data)
    }
}
