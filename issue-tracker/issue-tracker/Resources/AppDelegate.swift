//
//  AppDelegate.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/11.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        UserDefaults.standard.setValue(
//            (try? JSONEncoder().encode([
//                SettingIssueList(title: "직접 입력", imageURL: "issue_list_1".createLocalURL, isActivated: true),
//                SettingIssueList(title: "입력된 값 사용", imageURL: "issue_list_2".createLocalURL, isActivated: false)
//            ])),
//            forKey: IssueSettings.list.getPersistentKey()
//        )
        
//        UserDefaults.standard.setValue(
//            (try? JSONEncoder().encode([
//                SettingIssueQueryItem(query: "is:open", isOn: true),
//                SettingIssueQueryItem(query: "label:testLabel", isOn: true),
//                SettingIssueQueryItem(query: "visibility:visible", isOn: true),
//                SettingIssueQueryItem(query: "is:close"),
//                SettingIssueQueryItem(query: "label:noTestLabel"),
//                SettingIssueQueryItem(query: "visibility:inVisible")
//            ])),
//            forKey: IssueSettings.query.getPersistentKey()
//        )
        
        TransformableHelper.register()
        
        let checkCoreData = CheckDefaultCoreData()
        if checkCoreData.checkDefaultData() == false {
            checkCoreData.setDefaultSettingItems()
        }
        
        return true
    }
    
    var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        self.orientationLock
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
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

    func saveContext () {
      let context = persistentContainer.viewContext
      if context.hasChanges {
        do {
          try context.save()
        } catch {
          // Replace this implementation with code to handle the error appropriately.
          // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
          let nserror = error as NSError
          fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
      }
    }

}
