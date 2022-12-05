//
//  SettingDetailCellViewFactory.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/12/05.
//

import UIKit

class SettingDetailCellFactory {
    static func valueColorView() -> UIView {
        let view = UIView()
        return view
    }
    
    static func valueImageView() -> UIImageView {
        let view = UIImageView()
        return view
    }
    
    static func valueStringLabel() -> UILabel {
        let label = UILabel()
        return label
    }
    
    static func valueBoolSwitch() -> UISwitch {
        let boolSwitch = UISwitch()
        return boolSwitch
    }
}
