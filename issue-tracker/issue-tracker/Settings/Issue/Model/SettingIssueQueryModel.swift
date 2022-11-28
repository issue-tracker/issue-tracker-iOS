//
//  SettingIssueQueryModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/20.
//

import Foundation
import RxSwift
import RxRelay

final class SettingIssueQueryModel {
    typealias Item = SettingIssueQueryItem
    
    private var keyType: PersistentKey?
    
    let entitiesRelay = BehaviorRelay<[Item]>(value: [])
    let onMovedSubject = PublishSubject<Item>()
    private var disposeBag = DisposeBag()
    private(set) var entities = [Item]() {
        didSet {
            if let key = keyType?.getPersistentKey() {
                UserDefaults.standard.setValue(encoded(entities), forKey: key)
            }
            self.entitiesRelay.accept(entities)
        }
    }
    
    init(key: PersistentKey) {
        keyType = key
        if let data = UserDefaults.standard.object(forKey: key.getPersistentKey()) as? Data {
            let entities = decoded(data)
            self.entities = entities
            entitiesRelay.accept(entities)
        }
        
        onMovedSubject
            .subscribe(onNext: { self.setItemOn($0) })
            .disposed(by: disposeBag)
    }
    
    /// - Parameters:
    ///     - item: 새로 추가되어야 할 아이템.
    func setItemOn(_ entity: Item) {
        guard let previousItem = entities.first(where: {$0 == entity}) else { return }
        
        if entity.index != previousItem.index {
            guard swapEntities(from: previousItem.index, to: entity.index) else { return }
        }
        
        entities[entity.index] = entity
    }
    
    /// 위치와 상태만 바꾸고 싶을 때
    ///
    /// - Parameters:
    ///     - key: 변경해야 할 아이템의 키
    ///     - isOn: 활성화 상태
    ///     - at: index
    func setItemOn(key: String, isOn: Bool, at: Int) { // 도착점에 표시해주어야 할 Item. Id 는 같음.
        var item = entities.first(where: {$0.id.uuidString == key})
        item?.isOn = isOn
        
        guard let item = item else { return }
        setItemOn(item)
    }
    
    func getEntity(at index: Int) -> SettingIssueQueryItem? {
        guard 0..<entities.count ~= index else { return nil }
        return entities[index]
    }
    
    @discardableResult
    func swapEntities(from fromIndex: Int, to toIndex: Int) -> Bool {
        guard 0..<entities.count ~= fromIndex, 0..<entities.count ~= toIndex else { return false }
        entities.swapAt(fromIndex, toIndex)
        return true
    }
    
    func addEntity(_ entity: SettingIssueQueryItem) {
        entities.append(entity)
    }
}

extension SettingIssueQueryModel {
    func decoded(_ data: Data) -> [SettingIssueQueryItem] {
        (try? JSONDecoder().decode([Item].self, from: data)) ?? []
    }
    
    func encoded(_ list: [SettingIssueQueryItem]) -> Data {
        (try? JSONEncoder().encode(list)) ?? Data()
    }
}
