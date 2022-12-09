//
//  CheckDefaultCoreData.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/28.
//

import UIKit
import CoreData
// General: ["로그인 설정", "테마 설정"], Issue: ["목록 설정", "상세 창 설정", "기본 조회조건 설정"], Label: ["목록 설정", "상세 창 설정", "기본 조회조건 설정"], Milestone: ["목록 설정", "기본 조회조건 설정"]
class CheckDefaultCoreData {
//    let context: NSManagedObjectContext?
//
//    init() {
//        let appDelegate = UIApplication.shared.delegate as? AppDelegate
//        self.context = appDelegate?.persistentContainer.viewContext
//    }
//
//    func checkDefaultData() -> Bool {
//        guard let context else { return false }
//
//        let fetch = NSFetchRequest<NSManagedObject>(entityName: String(describing: "SettingItem"))
//
//        do {
//            let result = try context.fetch(fetch) as? [SettingItem]
//            return ((result ?? []).isEmpty == false)
//        } catch let error as NSError {
//            print(error)
//        }
//
//        return false
//    }
//
//    func setDefaultSettingItems() {
//        guard let context else { return }
//
//        let general = ["로그인 설정", "테마 설정"]
//        let issue = ["목록 설정", "상세 창 설정", "기본 조회조건 설정"]
//        let label = ["목록 설정", "상세 창 설정", "기본 조회조건 설정"]
//        let milestone = ["목록 설정", "상세 창 설정", "기본 조회조건 설정"]
//
//        func save(title: String, names: [String]) {
//            guard let entity = NSEntityDescription.entity(forEntityName: String(describing: "SettingItem"), in: context) else { return }
//            let object = NSManagedObject(entity: entity, insertInto: context)
//            let parentId = UUID()
//            object.setValue(parentId, forKey: "id")
//            object.setValue(title, forKey: "title")
//
//            var nameList = [SettingItem]()
//
//            for name in names {
//                let object = NSManagedObject(entity: entity, insertInto: context) as! SettingItem
//                object.setValue(UUID(), forKey: "id")
//                object.setValue(parentId, forKey: "parentId")
//                object.setValue(name, forKey: "title")
//                object.setValue(NSArray(), forKey: "value")
//                nameList.append(object)
//            }
//
//            object.setValue(nameList, forKey: "value")
//        }
//
//        save(title: "일반", names: general)
//        save(title: "이슈", names: issue)
//        save(title: "라벨", names: label)
//        save(title: "마일스톤", names: milestone)
//
//        do {
//            try context.save()
//        } catch let error as NSError {
//            print(error)
//        }
//    }
//
//    func removeAllSettingItems() {
//        guard let context else { return }
//
//        let fetch = NSFetchRequest<NSManagedObject>(entityName: String(describing: "SettingItem"))
//
//        do {
//            let result = try context.fetch(fetch) as? [SettingItem]
//
//            for item in result ?? [] {
//                context.delete(item)
//            }
//
//            try context.save()
//        } catch let error as NSError {
//            print(error)
//        }
//    }
}
