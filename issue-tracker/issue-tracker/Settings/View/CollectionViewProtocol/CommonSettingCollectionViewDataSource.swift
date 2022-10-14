//
//  CommonSettingCollectionViewDataSource.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/11.
//

import UIKit
import RxRelay
import RxSwift

class CommonSettingCollectionViewDataSource<Item: SettingItem & Codable>: NSObject, UICollectionViewDataSource {
    
    private var persistentKey: PersistentKey?
    private var model: SettingIssueListModel<Item>?
    private var collectionView: UICollectionView?
    private var disposeBag = DisposeBag()
    
    convenience init(collectionView: UICollectionView?, key: PersistentKey) {
        self.init()
        
        self.persistentKey = key
        self.collectionView = collectionView
        
        self.model = SettingIssueListModel<Item>(key: key)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model?.settingCount() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingCollectionViewCell", for: indexPath) as? SettingIssueCollectionViewCell else {
            
            let errorCell = UICollectionViewCell()
            errorCell.contentView.backgroundColor = .red
            return errorCell
        }
        
        if let entity = model?.getItem(index: indexPath.item) {
            cell.setEntity(entity, at: indexPath.item)
        }
        
        cell.buttonRXProperty
            .subscribe(onNext: { result in
                self.model?.onSettingSubject.onNext(result)
                self.collectionView?.reloadData()
            })
            .disposed(by: disposeBag)
        
        return cell
    }
}
