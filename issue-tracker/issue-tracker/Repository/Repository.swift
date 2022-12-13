//
//  Repository.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/12/09.
//

import Foundation
import CoreData

final class Repository {
    
    // MARK: - Singleton
    static let shared = Repository()
    
    // MARK: - Persistentce
    private(set) var persistent = CoreDataStack()
}
