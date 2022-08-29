//
//  IssueListProtocol.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/29.
//

import Foundation

enum ProtocolError: Error {
case jsonSerializingError
}

class IssueListProtocol: URLProtocol {
    
    var protocolClient: URLProtocolClient?
    var filePathURL: URL?
    var response: Result<Data, ProtocolError> {
        guard let url = filePathURL, let data = FileManager.default.contents(atPath: url.absoluteString) else {
            return .failure(.jsonSerializingError)
        }
        
        return .success(data)
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
                self.protocolClient?.urlProtocol(self, didReceive: URLResponse(), cacheStoragePolicy: .notAllowed)
                self.protocolClient?.urlProtocol(self, didLoad: data)
                self.protocolClient?.urlProtocolDidFinishLoading(self)
            case .failure(let error):
                self.protocolClient?.urlProtocol(self, didFailWithError: error)
            }
        }
    }
    
    override func stopLoading() {
        
    }
}
