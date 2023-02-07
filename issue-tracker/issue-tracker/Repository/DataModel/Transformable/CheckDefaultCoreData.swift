//
//  CheckDefaultCoreData.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/28.
//

import UIKit
import RxSwift
import CoreData

class CheckDefaultCoreData {
    
    init() {
        
        resetSettingItems()
        
        // MARK: - 테스트를 위해 계속 리스트를 초기화 함. 실제 동작 코드는 아래와 같음.
//        if checkDefaultData() == false {
//            resetSettingItems()
//        }
    }
    
    private func resetSettingItems() {
        removeAllSettingItems()
        setDefaultSettingItems()
    }

    private func checkDefaultData() -> Bool {
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

    private func setDefaultSettingItems() {
        guard let context = NSManagedObjectContext.viewContext else { return }
        
        guard let url = Bundle.main.url(forResource: "settingLists", withExtension: "json") else { return }
        
//        let general = ["로그인 설정", "테마 설정"]
//        let issue = ["목록 설정", "상세 창 설정", "기본 조회조건 설정"]
//        let label = ["목록 설정", "상세 창 설정", "기본 조회조건 설정"]
//        let milestone = ["목록 설정", "상세 창 설정", "기본 조회조건 설정"]
//
//        func save(title: String, names: [String]) {
//            for name in names {
//                guard let object = NSEntityDescription.insertNewObject(forEntityName: "SettingListItem", into: context) as? SettingListItem else {
//                    return
//                }
//
//                object.mainTitle = title
//                object.value = name
//            }
//        }
//
//        save(title: "일반", names: general)
//        save(title: "이슈", names: issue)
//        save(title: "라벨", names: label)
//        save(title: "마일스톤", names: milestone)

        do {
            let data = try Data(contentsOf: url)
            let settingJSON = try JSONDecoder().decode(SettingDecodable.self, from: data)
            
            for category in settingJSON.contents {
                guard let obj = NSEntityDescription.insertNewObject(forEntityName: String(describing: SettingCategory.self), into: context) as? SettingCategory else {
                    continue
                }
                
                obj.title = category.title.localized
                obj.listTypeValue = Int16(category.listTypeValue)
                
                var categoryItems = [SettingList]()
                for list in category.items {
                    guard let obj2 = NSEntityDescription.insertNewObject(forEntityName: String(describing: SettingList.self), into: context) as? SettingList else {
                        continue
                    }
                    
                    obj2.title = list.title.localized
                    obj2.parent = obj
                    
                    var listItems = [SettingListItem]()
                    for item in list.values {
                        guard let obj3 = NSEntityDescription.insertNewObject(forEntityName: String(describing: SettingListItem.self), into: context) as? SettingListItem else {
                            continue
                        }
                        
                        obj3.mainTitle = item.mainTitle.localized
                        obj3.subTitle = item.subTitle.localized
                        obj3.order = Int16(item.order)
                        
                        if let value = item.value as? Bool {
                            obj3.value = value ? kCFBooleanTrue : kCFBooleanFalse
                        } else {
                            obj3.value = item.value
                        }
                        
                        obj3.parent = obj2
                        
                        listItems.append(obj3)
                    }
                    
                    categoryItems.append(obj2)
                    obj2.values = NSOrderedSet(array: listItems)
                }
                
                obj.items = NSOrderedSet(array: categoryItems)
            }
            
            saveContext()
        } catch let error as NSError {
            print(error)
        }
    }

    private func removeAllSettingItems() {
        guard let context = NSManagedObjectContext.viewContext else { return }

        let fetch = SettingListItem.fetchRequest()

        do {
            let result = try context.fetch(fetch)
            for item in result {
                context.delete(item)
            }

            saveContext()
        } catch let error as NSError {
            print(error)
        }
    }
    
    private func saveContext() {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
