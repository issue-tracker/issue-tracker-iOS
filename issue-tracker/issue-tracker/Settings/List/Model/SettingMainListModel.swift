//
//  SettingMainListModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/29.
//

import Foundation
import CoreData

class SettingMainListModel {
    
    var context: NSManagedObjectContext?
    
    init(context: NSManagedObjectContext? = nil) {
        self.context = context ?? NSManagedObjectContext.viewContext
    }
    
    func getCategoryArray() -> [SettingCategory] {
        guard let context else {
            return []
        }
        
        var result = [SettingCategory]()
        
        do {
            result = try context.fetch(SettingCategory.fetchRequest())
        } catch {
            print(error)
        }
        
        return result
    }
    
    func getListArray(parent category: SettingCategory) -> [SettingList] {
        guard let context else {
            return []
        }

        let fetch = SettingList.fetchRequest()
        fetch.predicate = NSPredicate(
            format: "%K = %@",
            argumentArray: [#keyPath(SettingList.parent), category]
        )

        var result = [SettingList]()

        do {
            result = try context.fetch(fetch)
        } catch {
            print(error)
        }
        
        return result
    }
    
    func getItemArray(parent list: SettingList) -> [SettingListItem] {
        guard let context else {
            return []
        }

        let fetch = SettingListItem.fetchRequest()
        fetch.predicate = NSPredicate(
            format: "%K = %@",
            argumentArray: [#keyPath(SettingListItem.parent), list]
        )

        var result = [SettingListItem]()

        do {
            result = try context.fetch(fetch)
        } catch {
            print(error)
        }
        
        return result
    }
    
    private func getDataFromCoreData<CDObjectType: NSManagedObject, CDReturnType: NSManagedObject>(argumentObject: CDObjectType, objectKeyPath: String) -> [CDReturnType] {
        guard let context else {
            return []
        }
        
        let fetch = CDReturnType.fetchRequest()
        fetch.predicate = NSPredicate(
            format: "%K = %@",
            argumentArray: [objectKeyPath, argumentObject]
        )
        
        var result = [CDReturnType]()
        
        do {
            let fetchResult = try context.fetch(fetch)
            
            if let fetchResult = fetchResult as? [CDReturnType] {
                result = fetchResult
            }
        } catch {
            print(error)
        }
        
        return result
    }
}

enum SettingListType: Int, CaseIterable {
    case title = 0
    case item = 1
}

class SettingItemColor: NSObject, NSSecureCoding, Decodable {
    static var supportsSecureCoding: Bool = true
    
    func encode(with coder: NSCoder) {
        coder.encode(rgbRed, forKey: "rgbRed")
        coder.encode(rgbGreen, forKey: "rgbGreen")
        coder.encode(rgbBlue, forKey: "rgbBlue")
    }
    
    required convenience init?(coder: NSCoder) {
        let rgbRed = coder.decodeFloat(forKey: "rgbRed")
        let rgbGreen = coder.decodeFloat(forKey: "rgbGreen")
        let rgbBlue = coder.decodeFloat(forKey: "rgbBlue")
        
        self.init(rgbRed: rgbRed, rgbGreen: rgbGreen, rgbBlue: rgbBlue)
    }
    
    var rgbRed: Float
    var rgbGreen: Float
    var rgbBlue: Float
    
    init(rgbRed: Float, rgbGreen: Float, rgbBlue: Float) {
        self.rgbRed = rgbRed
        self.rgbGreen = rgbGreen
        self.rgbBlue = rgbBlue
    }
}

class SettingItemLoginActivate: NSObject, NSSecureCoding, Decodable {
    static var supportsSecureCoding: Bool = true
    
    func encode(with coder: NSCoder) {
        coder.encode(github, forKey: "github")
        coder.encode(kakao, forKey: "kakao")
        coder.encode(naver, forKey: "naver")
    }
    
    required convenience init?(coder: NSCoder) {
        let github = coder.decodeBool(forKey: "github")
        let kakao = coder.decodeBool(forKey: "kakao")
        let naver = coder.decodeBool(forKey: "naver")
        
        self.init(github: github, kakao: kakao, naver: naver)
    }
    
    var github = true
    var kakao = true
    var naver = true
    
    init(github: Bool = false, kakao: Bool = false, naver: Bool = false) {
        self.github = github
        self.kakao = kakao
        self.naver = naver
    }
}
