//
//  SettingTableViewCellFactory.swift
//  issue-tracker
//
//  Created by 백상휘 on 2023/02/13.
//

import UIKit

class SettingTableViewCellFactory {
    static func makeCell(in tableView: UITableView, at indexPath: IndexPath, _ item: Any?) -> UITableViewCell {
        guard let item else { return .init() }
        
        if let itemValue = item as? ColorSets {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingDetailMultiItemCell.reuseIdentifier, for: indexPath) as? SettingDetailMultiItemCell else {
                return UITableViewCell()
            }
            
            cell.setEntity(itemValue)
            
            return cell
            
        } else if let itemValue = item as? LoginActivate {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingDetailMultiItemCell.reuseIdentifier, for: indexPath) as? SettingDetailMultiItemCell else {
                return UITableViewCell()
            }
            
            cell.setEntity(itemValue)
            
            return cell
            
        } else if let itemBoolean = cfCast(item, to: CFBoolean.self) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingDetailMonoItemCell.reuseIdentifier, for: indexPath) as? SettingDetailMonoItemCell else {
                return UITableViewCell()
            }
            
            cell.setEntity(itemBoolean == kCFBooleanTrue)
            cell.makeUI()
            
            return cell
        }
        
        return UITableViewCell()
    }
}
