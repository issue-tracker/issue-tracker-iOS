//
//  SettingTableViewDelegate.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/11.
//

import UIKit

protocol SettingTableViewDelegateGenerator {
    associatedtype VM
    var viewModel: VM { get }
    init(vm: VM, binding: ViewBinding?)
}

class SettingTableViewDelegate<VM: SettingViewModel>: NSObject, UITableViewDelegate, SettingTableViewDelegateGenerator, ViewBindable {
    
    var binding: ViewBinding?
    
    let viewModel: VM
    
    required init(vm: VM, binding: ViewBinding?) {
        self.viewModel = vm
        self.binding = binding
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.cellItems(section: indexPath.section)
        let nextView = item[indexPath.row].getNextView()
        nextView.view.backgroundColor = .systemBackground
        tableView.cellForRow(at: indexPath)?.isSelected = false
        binding?.bindableHandler?(nextView, self)
    }
}
