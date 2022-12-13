//
//  CoreDataStack.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/12/13.
//

import CoreData

final class CoreDataStack {
    typealias Entity = NSManagedObject
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SettingDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
