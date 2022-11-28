//
//  SettingTableViewDataSource.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/11.
//

import UIKit

class SettingTableViewDataSource<Cell: UITableViewCell & CellEntityAdaptable>: NSObject, UITableViewDataSource {
    
    private let model: SettingMainModel
    
    private var cellHandler: ((UITableView, SettingCategory, IndexPath) -> Cell)
    
    init(model: SettingMainModel, _ cellHandler: @escaping (UITableView, SettingCategory, IndexPath) -> Cell) {
        self.model = model
        self.cellHandler = cellHandler
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        model.allSections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        model.allSections[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.sectionItems(section: section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entity = model.sectionItems(section: indexPath.section)[indexPath.item]
        return cellHandler(tableView, entity, indexPath)
    }
}
