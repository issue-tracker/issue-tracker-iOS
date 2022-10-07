//
//  SettingsViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/21.
//

import UIKit
import SnapKit

/**
 UITableView(https://developer.apple.com/design/human-interface-guidelines/components/layout-and-organization/lists-and-tables/)
 
 Best practices
 
 계층구조보단 텍스트의 list를 보여주는 것이 좋다. table 은 어떤 타입의 콘텐츠든 포함할 수 있지만, row-based 형태는 살펴보고 읽기 편하다. 만약 다양한 타입의 크기를 가진 이미지 등을 보여주고 싶다면 CollectionView 가 좋다.

 테이블을 사용자가 직접 변경할 수 있게 하자. 추가/삭제를 못하는 상황이라도 list의 위치는 변경하는 방법을 제공하는 것이 좋다. 사람들이 테이블을 선택하기 전에 edit mode 에 들어갈 수 있도록 해야 한다.(SettingIssueQueryViewController 반영)

 테이블의 아이템을 선택했다면 적절한 피드백을 줘야 한다. 피드백은 아이템을 선택하여 새로운 뷰를 보여주거나 선택하여 상태를 바꾸는 두 개의 경우에 따라 다양할 수 있다. 일반적으로 테이블은 계층구조를 사용자들이 볼 수 있도록 한다. 반대로 테이블은 간단하게 옵션값만을 나열한 테이블의 경우는 이미지가 표시되기 전 행을 짧게 강조 표시할 수도 있다.
 
 Content
 텍스트를 간결하게 하여 편하게 읽을 수 있도록 해야 한다. 간결한 텍스트는 누락을 최소화하고 텍스트를 읽기 쉽게 한다. 긴 텍스트가 있다면 그에 대한 대안을 고려해보자. 예를 들어, 아이템의 타이틀만을 표시하고 나머지는 상세 창에서 확인하도록 하는 등을 고려해보자.

 텍스트의 가독성을 고려하는 것은 텍스트를 줄이거나 자르는 것으로 고려될 수 있다. 테이블이 좁은 경우, 사용자가 다양한 사이즈의 뷰를 선택하는 상황에도 컨텐츠는 쉽게 읽을 수 있어야 한다. 가끔 중간의 텍스트를 줄여서 앞뒤만 보이게 하는 것도 도움이 된다.

 여러 개의 컬럼이 있는 경우에는 설명 컬럼을 사용해보자. 제목 두문자 스타일의 명사구 혹은 짧은 명사구를 사용하고 구두점은 찍지 말자. Heading을 하지 않는다면 라벨이나 헤더를 사용해서 문맥을 이해하는 것을 돕도록 하자.
 */
class SettingsViewController: CommonProxyViewController {

    let viewModel = SettingsViewModel()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        tableView.separatorStyle = .none
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextView = viewModel[indexPath.section][indexPath.row].getNextView()
        nextView.view.backgroundColor = .systemBackground
        tableView.cellForRow(at: indexPath)?.isSelected = false
        navigationController?.pushViewController(nextView, animated: true)
    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.settingsCategory.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.settingsCategory[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseIdentifier, for: indexPath) as? SettingsCell else {
            return UITableViewCell()
        }
        
        cell.label.text = viewModel[indexPath.section][indexPath.row].getName()
        
        return cell
    }
}

class SettingsCell: UITableViewCell {
    let customBackgroundView = UIView()
    let label = CommonLabel(fontMultiplier: 1.45)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeUI()
    }
    
    private func makeUI() {
        contentView.addSubview(customBackgroundView)
        customBackgroundView.addSubview(label)
        
        label.backgroundColor = .systemBackground
        label.textAlignment = .left
        
        customBackgroundView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(5)
            $0.trailing.bottom.equalToSuperview().inset(5)
        }
        
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
