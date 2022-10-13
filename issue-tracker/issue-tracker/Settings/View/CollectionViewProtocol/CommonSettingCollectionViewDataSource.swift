//
//  CommonSettingCollectionViewDataSource.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/11.
//

import UIKit
import RxRelay
import RxSwift

class CommonSettingCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    let model = SettingIssueListModel()
    private var collectionView: UICollectionView?
    convenience init(collectionView: UICollectionView?) {
        self.init()
        self.collectionView = collectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.settingCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingCollectionViewCell", for: indexPath) as? SettingCollectionViewCell else {
            
            let errorCell = UICollectionViewCell()
            errorCell.contentView.backgroundColor = .red
            return errorCell
        }
        
        if let entity = model.getItem(index: indexPath.item) {
            cell.setEntity(entity, at: indexPath.item)
        }
        
        cell.buttonRXProperty
            .subscribe(onNext: { result in
                self.model.onSettingSubject.onNext(result)
                self.collectionView?.reloadData()
            })
            .disposed(by: model.disposeBag)
        
        return cell
    }
}
