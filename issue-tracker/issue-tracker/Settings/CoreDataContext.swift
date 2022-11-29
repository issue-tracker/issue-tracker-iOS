//
//  CoreDataContext.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/28.
//

import UIKit
import CoreData

protocol CoreDataContext {
    
}

extension CoreDataContext {
    var managedContext: NSManagedObjectContext? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }
}
