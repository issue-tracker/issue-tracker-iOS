//
//  MainListTableViewCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/05.
//

import UIKit
import FlexLayout

class MainListTableViewCell<T: Codable>: UITableViewCell {
    
    var bindableHandler: ((Any, ViewBinding) -> Void)?
    
    private(set) var titleLabel = CommonLabel(fontMultiplier: 1.2)
    private(set) var profileView = ProfileImageButton()
    private(set) var dateLabel = CommonLabel(fontMultiplier: 0.9)
    private(set) var contentsLabel = CommonLabel()
    
    let paddingView = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    func makeUI() { }
    func setEntity(_ entity: T) { }
    
    func setLayout() {
        layoutIfNeeded()
        paddingView.flex.layout()
        paddingView.setCornerRadius(5)
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

func solution(_ ingredient:[Int]) -> Int {
    guard var index = ingredient.firstIndex(of: 1) else {
        return 0
    }
    
    var ingredient = ingredient
    var result = 0
    
    while let fourIngredients = ingredient.getFour(index) {
        ingredient.removeIngredients(fourIngredients, at: index) {
            result += 1
        }
        index += 1
    }
    
    return result
}

extension Array where Element == Int {
    func getFour(_ index: Int) -> Self? {
        guard 0..<(self.endIndex-3) ~= index else {
            return nil
        }
        
        return [self[index], self[index+1], self[index+2], self[index]]
    }
    
    mutating func removeIngredients(_ arr: [Int], at index: Int, _ completionHandler: @escaping () -> Void) {
        if arr == [1,2,3,1] {
            self.removeSubrange(index..<index+3)
            completionHandler()
        }
        
        if let fourIngredients = self.getFour(index) {
            self.removeIngredients(fourIngredients, at: index, completionHandler)
        }
        
        return
    }
}
