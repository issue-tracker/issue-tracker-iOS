//
//  SettingTableViewCellFactory.swift
//  issue-tracker
//
//  Created by 백상휘 on 2023/02/13.
//

import UIKit

class SettingTableViewCellFactory {
    static func makeCell(in tableView: UITableView, at indexPath: IndexPath, _ item: SettingListItem?) -> UITableViewCell {
        guard let value = item?.value else { return .init() }
        
        if let itemValue = value as? SettingItemColor {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingDetailMultiItemCell.reuseIdentifier, for: indexPath) as? SettingDetailMultiItemCell else {
                return UITableViewCell()
            }
            
            cell.setEntity(itemValue)
            
            return cell
            
        } else if let itemValue = value as? SettingItemLoginActivate {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingDetailMultiItemCell.reuseIdentifier, for: indexPath) as? SettingDetailMultiItemCell else {
                return UITableViewCell()
            }
            
            cell.setEntity(itemValue)
            
            return cell
            
        } else if let itemBoolean = value as? Bool {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingDetailMonoItemCell.reuseIdentifier, for: indexPath) as? SettingDetailMonoItemCell else {
                return UITableViewCell()
            }
            
            cell.setEntity(itemBoolean)
            cell.makeUI()
            
            return cell
        }
        
        return UITableViewCell()
    }
}
