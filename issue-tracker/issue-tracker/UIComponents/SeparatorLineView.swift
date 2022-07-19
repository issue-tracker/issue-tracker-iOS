//
//  SeparatorLineView.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/19.
//

import UIKit

class SeparatorLineView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    private func makeUI() {
        frame.size.height = 1
        backgroundColor = UIColor.separator
    }
}
