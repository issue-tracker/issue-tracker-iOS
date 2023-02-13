//
//  SettingManagedObjectCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2023/02/13.
//

import UIKit
import CoreData
import RxSwift

class SettingManagedObjectCell: UITableViewCell {
    internal var disposeBag = DisposeBag()
    
    var managedObject: SettingListItem?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
}
