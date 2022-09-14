//
//  IssueDetailTableViewCellSeparator.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/14.
//

import UIKit

class IssueDetailTableViewCellSeparator: UITableViewCell, IssueDetailCellCommonHeight {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func getHeight() -> Float {
        return 30
    }
    
    func setEntity(_ entity: IssueListComment) {
        
    }
}
