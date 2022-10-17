//
//  SettingTableViewDataSource.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/11.
//

import UIKit

class SettingTableViewDataSource<Cell: UITableViewCell & SettingCategoryAcceptable>: NSObject, UITableViewDataSource {
    
    private let viewModel = SettingMainViewModel()
    
    private var cellHandler: ((UITableView, SettingCategory, IndexPath) -> Cell)
    
    init(_ cellHandler: @escaping (UITableView, SettingCategory, IndexPath) -> Cell) {
        self.cellHandler = cellHandler
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sectionItems.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.sectionItems[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cellItems(section: section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entity = viewModel.cellItems(section: indexPath.section)[indexPath.item]
        return cellHandler(tableView, entity, indexPath)
        

    }
}
