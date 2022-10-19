//
//  SettingTableViewDelegate.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/11.
//

import UIKit

class SettingTableViewDelegate: NSObject, UITableViewDelegate, ViewBindable {
    
    var binding: ViewBinding?
    private let viewModel = SettingMainModel()
    
    init(binding: ViewBinding?) {
        self.binding = binding
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.sectionItems(section: indexPath.section)
        guard let nextView = item[indexPath.row].getNextView() else {
            return
        }
        
        nextView.view.backgroundColor = .systemBackground
        tableView.cellForRow(at: indexPath)?.isSelected = false
        binding?.bindableHandler?(nextView, self)
    }
}