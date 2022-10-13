//
//  AssetExtractor+Extensions.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/13.
//

import Foundation
import UIKit

extension String {
    var createLocalURL: URL? {
        let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let url = cacheDir.appendingPathComponent("\(self).png")
        
        if FileManager.default.fileExists(atPath: url.path) {
            return url
        }
        
        guard let image = UIImage(named: self), let data = image.pngData() else {
            return nil
        }
        
        FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        return url
    }
}
