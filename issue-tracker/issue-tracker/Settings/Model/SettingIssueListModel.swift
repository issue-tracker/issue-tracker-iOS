//
//  SettingIssueListModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/13.
//

import Foundation
import RxSwift

class SettingIssueListModel {
    private var issueListCases: [SettingIssueList] = []
    
    private(set) var onSettingSubject = PublishSubject<(Int, Bool)>()
    var disposeBag = DisposeBag()
    
    private var decoded: (Data) -> [SettingIssueList] = { data in
        (try? JSONDecoder().decode([SettingIssueList].self, from: data)) ?? []
    }
    
    private var encoded: ([SettingIssueList]) -> Data = { list in
        (try? JSONEncoder().encode(list)) ?? Data()
    }
    
    init() {
        onSettingSubject
            .subscribe(onNext: { result in
                self.setItemOn(result.0)
            })
            .disposed(by: disposeBag)
        
        if let data = UserDefaults.standard.object(forKey: "SettingIssueList") as? Data {
            issueListCases = decoded(data)
        }
    }
    
    func settingCount() -> Int {
        issueListCases.count
    }
    
    func getItem(index: Int) -> SettingIssueList? {
        guard 0..<issueListCases.count ~= index else {
            return nil
        }
        
        return issueListCases[index]
    }
    
    func getItem(title: String) -> SettingIssueList? {
        issueListCases.first(where: {$0.title == title})
    }
    
    @discardableResult
    func setIssueItem(_ item: SettingIssueList) -> Bool {
        
        for (index, listCase) in issueListCases.enumerated() {
            issueListCases[index].isActivated = listCase.title == item.title ? item.isActivated : false
        }
        
        UserDefaults.standard.setValue(encoded(issueListCases), forKey: "SettingIssueList")
        
        return false
    }
    
    func setItemOn(_ index: Int) {
        issueListCases = issueListCases.map({
            var item = $0
            item.isActivated = false
            return item
        })
        
        issueListCases[index].isActivated = true
        UserDefaults.standard.setValue(encoded(issueListCases), forKey: "SettingIssueList")
    }
}

struct SettingIssueList: Codable {
    var title: String
    var imageURL: URL?
    var isActivated: Bool
}
