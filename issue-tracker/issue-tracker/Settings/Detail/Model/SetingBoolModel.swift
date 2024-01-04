//
//  SetingBoolModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2023/02/20.
//

import Foundation
import CoreData

class SetingBoolModel: SettingModelCaller {
    override init(_ itemName: String) {
        super.init(itemName)
    }
}

/// SettingListItem 을 CoreData 에서 불러와서 로컬 프로퍼티에 저장해놓는 역할을 합니다.
///
/// 불러와지는 시점은 init 이므로, SettingListItem 의 mainTitle 을 생성자 파라미터로 전달해주셔야 합니다.
class SettingModelCaller {
    let settingListItem: SettingListItem?
    
    init(_ itemName: String) {
        do {
            // mainTitle 은 리스트에 보이는 타이틀, 해당 타이틀이 겹치면 설정화면 자체의 오류이기 때문에 mainTitle 은 키 값으로 채택될 수 있습니다.
            let fetch = SettingListItem.fetchRequest()
            fetch.predicate = NSPredicate(format: "%K = %@", [#keyPath(SettingListItem.mainTitle): itemName])
            
            self.settingListItem = try NSManagedObjectContext.viewContext?.fetch(fetch).first
        } catch {
            self.settingListItem = nil
            print(error)
        }
    }
}
