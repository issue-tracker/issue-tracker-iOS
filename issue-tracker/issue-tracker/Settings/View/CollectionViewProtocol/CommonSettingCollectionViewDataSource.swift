//
//  CommonSettingCollectionViewDataSource.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/11.
//

import UIKit
import RxRelay
import RxSwift

class CommonSettingCollectionViewDataSource<Item: SettingItem & Codable, Cell: UICollectionViewCell & SettingItemAcceptable>: NSObject, UICollectionViewDataSource {
    
    private var persistentKey: PersistentKey?
    private var model: SettingIssueListModel<Item>?
    
    var onSettingSubject: PublishRelay<(Int, Bool)>? {
        model?.onSettingSubject
    }
    
    private var cellHandler: ((Cell, Item, IndexPath) -> Cell)
    
    init(model: SettingIssueListModel<Item>, _ cellHandler: @escaping ((Cell, Item, IndexPath) -> Cell)) {
        self.cellHandler = cellHandler
        self.model = model
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model?.settingCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell,
            let entity = model?.getItem(index: indexPath.item)
        else {
            return Cell()
        }
        
        return cellHandler(cell, entity, indexPath)
    }
}
