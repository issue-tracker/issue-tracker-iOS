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
    let coreDataStack = CoreDataStack()
    var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        self.orientationLock
    }
}

extension NSManagedObjectContext {
    static var viewContext: NSManagedObjectContext? {
        (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.context
    }
}
