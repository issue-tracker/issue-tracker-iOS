//
//  CommonSettingCollectionViewDelegate.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/11.
//

import UIKit
import RxSwift

class CommonSettingCollectionViewDelegate<Item: SettingItem, Cell: UICollectionViewCell & SettingSelectable>: NSObject, UICollectionViewDelegate {
    
    var selectItemHandler: ((Observable<(index: Int, value: Any)>)->Void)?
    
    convenience init(_ selectItemHandler: @escaping (Observable<(index: Int, value: Any)>)->Void) {
        self.init()
        self.selectItemHandler = selectItemHandler
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? Cell else {
            return
        }
        
        if let property = cell.controlProperty {
            selectItemHandler?(property.map{ (index: indexPath.item, value: $0) })
        }
    }
}
