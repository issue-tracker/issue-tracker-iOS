//
//  Repository.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/12/09.
//

import CoreData

final class Repository {
    
    static let shared = Repository()
    
    var context: NSManagedObjectContext? {
        persistentContainer.viewContext
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "SettingDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            try context.save()
        }
    }
    
    private func getEntity<Entity: NSManagedObject>(_ t: Entity.Type) -> NSEntityDescription? {
        let nameOfEntity = String(describing: t.self)
        return NSEntityDescription.entity(forEntityName: nameOfEntity, in: persistentContainer.viewContext)
    }
    
    func getNewEntity<Entity: NSManagedObject>(_ entityType: Entity.Type) -> Entity? {
        
        guard
            let entity = getEntity(entityType),
            let result = NSManagedObject(entity: entity, insertInto: context) as? Entity
        else {
            return nil
        }
        
        return result
    }
    
    func fetchEntities<Entity: NSManagedObject>(_ entityType: Entity.Type) throws -> [Entity] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Entity>(
            entityName: String(describing: entityType.self)
        )
        
        return try context.fetch(fetchRequest)
    }
}
