//
//  CommonSettingTableViewDataSource.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/11.
//

import UIKit

protocol SettingTableViewDataSourceGenerator {
    typealias CELLHandler = (SettingItem, IndexPath) -> UITableViewCell
    associatedtype VM
    var cellHandler: CELLHandler { get set }
    var viewModel: VM { get }
    init(vm: VM, _ cellHandler: @escaping CELLHandler)
}

class CommonSettingTableViewDataSource<VM: SettingsViewModel>: NSObject, UITableViewDataSource, SettingTableViewDataSourceGenerator {
    
    var cellHandler: CELLHandler
    let viewModel: VM
    
    required init(vm: VM, _ cellHandler: @escaping (SettingItem, IndexPath) -> UITableViewCell) {
        self.cellHandler = cellHandler
        self.viewModel = vm
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sectionItems.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.sectionItems[section] as? String
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cellItems(section: section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellHandler(viewModel.cellItems(section: indexPath.section)[indexPath.item], indexPath)
    }
}