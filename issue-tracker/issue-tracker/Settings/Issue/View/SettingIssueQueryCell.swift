//
//  SettingIssueQueryCell.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/20.
//

import SnapKit

final class SettingIssueQueryCell: UITableViewCell {
    let label = CommonLabel()
    
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
    
    private func makeUI() {
        contentView.addSubview(label)
        backgroundColor = .systemBackground
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setEntity(_ entity: SettingIssueQueryItem) {
        label.text = entity.query
        
        let queryStatus: QueryStatusColor = entity.isOn ? .activeColor : .deActiveColor
        backgroundColor = UIColor(named: queryStatus.getColorName())
    }
}
