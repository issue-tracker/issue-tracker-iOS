//
//  CommonSettingCollectionViewDataSource.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/11.
//

import UIKit

class CommonSettingCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    let model = SettingIssueListModel()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.settingCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingCollectionViewCell", for: indexPath) as? SettingCollectionViewCell else {
            
            let errorCell = UICollectionViewCell()
            errorCell.contentView.backgroundColor = .red
            return errorCell
        }
        
        let entity = model.getItem(index: indexPath.item)
        cell.setEntity(entity)
        
        return cell
    }
}
