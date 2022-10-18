//
//  SettingIssueListModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/13.
//

import Foundation
import RxSwift
import RxRelay

final class SettingIssueListModel<Item: SettingItem & Codable> {
    private var keyType: PersistentKey?
    
    private var issueListCases: [Item] = []
    private(set) var onSettingSubject = PublishRelay<(Int, Bool)>()
    
    var itemsObservable = BehaviorRelay<[Item]>.init(value: [])
    var disposeBag = DisposeBag()
    
    init(key: PersistentKey) {
        self.keyType = key
        onSettingSubject
            .subscribe(onNext: { self.setItemOn($0.0) })
            .disposed(by: disposeBag)
        
        if let key = keyType, let data = UserDefaults.standard.object(forKey: key.getPersistentKey()) as? Data {
            issueListCases = decoded(data)
            itemsObservable.accept(issueListCases)
        }
    }
    
    func settingCount() -> Int {
        issueListCases.count
    }
    
    func getItem(index: Int) -> Item? {
        guard 0..<issueListCases.count ~= index else {
            return nil
        }
        
        return issueListCases[index]
    }
    
    func getItem(title: String) -> Item? {
        issueListCases.first(where: {$0.title == title})
    }
    
    @discardableResult
    func setIssueItem(_ item: Item) -> Bool {
        
        for (index, listCase) in issueListCases.enumerated() {
            issueListCases[index].isActivated = listCase.title == item.title ? item.isActivated : false
        }
        
        saveIssueListCases()
        
        return false
    }
    
    func setItemOn(_ index: Int) {
        issueListCases = issueListCases.map({
            var item = $0
            item.isActivated = false
            return item
        })
        
        issueListCases[index].isActivated = true
        saveIssueListCases()
    }
    
    private func saveIssueListCases() {
        if let key = keyType {
            UserDefaults.standard.setValue(encoded(issueListCases), forKey: key.getPersistentKey())
        }
    }
}

extension SettingIssueListModel where Item: SettingItem & Codable {
    func decoded(_ data: Data) -> [Item] {
        (try? JSONDecoder().decode([Item].self, from: data)) ?? []
    }
    
    func encoded(_ list: [Item]) -> Data {
        (try? JSONEncoder().encode(list)) ?? Data()
    }
}

struct SettingIssueList: Codable, SettingItem {
    var title: String
    var imageURL: URL?
    var isActivated: Bool
}
