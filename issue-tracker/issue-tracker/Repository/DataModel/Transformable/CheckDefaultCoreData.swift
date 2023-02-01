//
//  CheckDefaultCoreData.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/28.
//

import UIKit
import CoreData

class CheckDefaultCoreData {
    
    init() {
        print("Default!!!, \(checkDefaultData())")
        setDefaultSettingItems()
        print("Default!!!, \(checkDefaultData())")
        removeAllSettingItems()
        print("Default!!!, \(checkDefaultData())")
    }

    func checkDefaultData() -> Bool {
        guard let context = NSManagedObjectContext.viewContext else {
            return false
        }

        let fetch = SettingListItem.fetchRequest()

        do {
            let result = try context.fetch(fetch)
            let isAlreadyDefined = result.isEmpty == false
            
            if isAlreadyDefined {
                print(result)
            }
            
            return isAlreadyDefined
        } catch let error as NSError {
            print(error)
        }

        return false
    }

    func setDefaultSettingItems() {
        guard let context = NSManagedObjectContext.viewContext else { return }

        let general = ["로그인 설정", "테마 설정"]
        let issue = ["목록 설정", "상세 창 설정", "기본 조회조건 설정"]
        let label = ["목록 설정", "상세 창 설정", "기본 조회조건 설정"]
        let milestone = ["목록 설정", "상세 창 설정", "기본 조회조건 설정"]

        func save(title: String, names: [String]) {
            for name in names {
                guard let object = NSEntityDescription.insertNewObject(forEntityName: "SettingListItem", into: context) as? SettingListItem else {
                    return
                }
                
                object.mainTitle = title
                object.value = name
            }
        }

        save(title: "일반", names: general)
        save(title: "이슈", names: issue)
        save(title: "라벨", names: label)
        save(title: "마일스톤", names: milestone)

        do {
            try context.save()
        } catch let error as NSError {
            print(error)
        }
    }

    func removeAllSettingItems() {
        guard let context = NSManagedObjectContext.viewContext else { return }

        let fetch = SettingListItem.fetchRequest()

        do {
            let result = try context.fetch(fetch)
            for item in result {
                context.delete(item)
            }

            try context.save()
        } catch let error as NSError {
            print(error)
        }
    }
}
