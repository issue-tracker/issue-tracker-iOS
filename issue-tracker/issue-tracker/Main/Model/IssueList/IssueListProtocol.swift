//
//  IssueListProtocol.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/29.
//

import Foundation

enum ProtocolError: Error {
    case jsonSerializingError(String)
    case urlConfirmationError(String)
}

class IssueListProtocol: URLProtocol {
    
    static var url: URL? {
        
        guard let urlString = Bundle.main.path(forResource: "Issues", ofType: "json") else {
            return nil
        }
        
        return URL(string: urlString)
    }
    /**중략**/
    var protocolClient: URLProtocolClient?
    var filePathURL: URL?
    var response: Result<Data, ProtocolError> {
        guard var url = Self.url else {
            return .failure(.urlConfirmationError("filePathURL is nil"))
        }

        while url.lastPathComponent.lowercased().contains("json") == false {
            url = url.deletingLastPathComponent()
        }

        for urlString in [url.absoluteString, url.relativePath, url.relativeString] {
            if let data = FileManager.default.contents(atPath: urlString) {
                return .success(data)
            }
        }

        return .failure(.jsonSerializingError("no file at '\(url.relativePath)'"))
    }
    
    convenience init(task: URLSessionTask,
      cachedResponse: CachedURLResponse?,
                     client: URLProtocolClient?) {
        
        self.init()
        self.filePathURL = task.currentRequest?.url
        self.protocolClient = client
    }
    
    override class func canInit(with task: URLSessionTask) -> Bool {
        return true
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        DispatchQueue.global(qos: .default).async {
            switch self.response {
            case .success(let data):
                self.protocolClient?.urlProtocol(self, didLoad: data)
            case .failure(let error):
                self.protocolClient?.urlProtocol(self, didFailWithError: error)
            }
            
            self.protocolClient?.urlProtocolDidFinishLoading(self)
        }
    }
    
    override func stopLoading() {}
}
