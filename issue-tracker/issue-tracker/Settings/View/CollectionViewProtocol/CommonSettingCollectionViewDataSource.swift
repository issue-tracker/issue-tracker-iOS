//
//  CommonSettingCollectionViewDataSource.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/11.
//

import UIKit

class CommonSettingCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingCollectionViewCell", for: indexPath) as? SettingCollectionViewCell else {
            
            let errorCell = UICollectionViewCell()
            errorCell.contentView.backgroundColor = .red
            return errorCell
        }
        
        cell.setState("section\(indexPath.section), index\(indexPath.item)", image: UIImage(named: "login_octocat"))
        
        return cell
    }
}
