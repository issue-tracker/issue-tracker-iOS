//
//  SettingTableViewCellFactory.swift
//  issue-tracker
//
//  Created by 백상휘 on 2023/02/13.
//

import UIKit

class SettingTableViewCellFactory {
    static func makeCell(in tableView: UITableView, at indexPath: IndexPath, _ item: SettingListItem?) -> UITableViewCell {
        guard
            let value = item?.value,
            let typeName = item?.typeName,
            let typeOfValue = CoreDataStack.ValueType.getType(query: typeName)
        else {
            return .init()
        }
        
        switch typeOfValue {
        case .boolean:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingDetailMonoItemCell.reuseIdentifier, for: indexPath) as? SettingDetailMonoItemCell else {
                return UITableViewCell()
            }
            
            cell.setTitle(item?.desc)
            if let value = value as? Bool {
                cell.setEntity(value)
            }
            return cell
        case .range:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingDetailMultiItemCell.reuseIdentifier, for: indexPath) as? SettingDetailMultiItemCell else {
                return UITableViewCell()
            }
            
            cell.setTitle(item?.desc)
            if let value = value as? SettingItemRange {
                cell.setEntity(value)
            }
            return cell
        case .login_activate:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingDetailMultiItemCell.reuseIdentifier, for: indexPath) as? SettingDetailMultiItemCell else {
                return UITableViewCell()
            }
            
            cell.setTitle(item?.desc)
            if let value = value as? SettingItemLoginActivate {
                cell.setEntity(value)
            }
            return cell
        case .rgb_color:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingDetailMultiItemCell.reuseIdentifier, for: indexPath) as? SettingDetailMultiItemCell else {
                return UITableViewCell()
            }
            
            cell.setTitle(item?.desc)
            if let value = value as? SettingItemColor {
                cell.setEntity(value)
            }
            return cell
        }
    }
}
