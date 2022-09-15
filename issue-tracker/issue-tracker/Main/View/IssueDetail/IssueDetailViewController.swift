//
//  IssueDetailViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/08.
//

import UIKit
import SnapKit
import FlexLayout

enum IssueStatus {
    case open
    case closed
}

class IssueDetailViewController: CommonProxyViewController {
    
    private var issueId: Int?
    private var entity: IssueListEntity?
    private var issueStatus: IssueStatus = .closed
    
    private var model: IssueDetailViewModel?
    
    convenience init(_ id: Int, status: IssueStatus) {
        self.init()
        self.issueId = id
        self.issueStatus = status
    }
    
    private let containerView = UIView()
    
    private let additionalInfoView = UIView()
    private let statusLabel: CommonLabel = {
        let label = CommonLabel(fontMultiplier: 0.9)
        label.setCornerRadius(8)
        label.textColor = .secondaryLabel
        return label
    }()
    private let additionalInfoScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.backgroundColor = .lightGray
        scrollView.setCornerRadius(8)
        return scrollView
    }()
    
    private lazy var contentsTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .purple
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setEntity()
        
        contentsTableView.register(IssueDetailTableViewCellSeparator.self, forCellReuseIdentifier: IssueDetailTableViewCellSeparator.reuseIdentifier)
        contentsTableView.register(IssueDetailCommentTableViewCell.self, forCellReuseIdentifier: IssueDetailCommentTableViewCell.reuseIdentifier)
        
        view.addSubview(containerView)
        containerView.backgroundColor = .yellow
        
        let isOpened = issueStatus == .open
        statusLabel.backgroundColor = (isOpened ? UIColor.green : UIColor.purple).withAlphaComponent(0.8)
        statusLabel.text = (isOpened ? "open" : "closed")
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerView.flex.define { flex in
            // 고정값으로 처리하는 이유는 나중에도 layout을 다시 정의하도록 하기 때문.
            flex.addItem(additionalInfoView).height(60).direction(.row).padding(8).define { flex in
                flex.addItem(statusLabel).height(100%).aspectRatio(1).marginRight(4)
                flex.addItem(additionalInfoScrollView).grow(1)
            }
            flex.addItem(contentsTableView).grow(1).margin(UIEdgeInsets(top: 0, left: 8, bottom: 8, right: 8))
        }
        
        containerView.layoutIfNeeded()
        containerView.flex.layout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func setEntity() {
        guard let id = issueId, let model = IssueDetailViewModel(issueId: id) else { return }
        self.model = model
        
        do {
            try model.getDetailEntity()
                .subscribe(onNext: { entity in
                    self.entity = entity
                    DispatchQueue.main.async {
                        self.navigationItem.title = entity?.title
                    }
                })
                .disposed(by: model.bag)
            try model.getEmojis()
                .subscribe(onNext: { [weak self] result in
                    guard let emojis = result?.getEncodedEmojis(), let scrollView = self?.additionalInfoScrollView else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        for (index, emoji) in emojis.enumerated() {
                            let label = CommonLabel()
                            label.text = emoji
                            
                            scrollView.flex.direction(.row)
                                .addItem(label)
                                .width(scrollView.frame.height)
                                .height(scrollView.frame.height)
                                .marginLeft(index == 0 ? 8 : 4)
                                .marginRight(index == emojis.index(before: emojis.endIndex) ? 8 : 4)
                        }
                        scrollView.flex.layout()
                        scrollView.reloadContentSizeWidth()
                    }
                })
                .disposed(by: model.bag)
        } catch {
            print(error)
        }
    }
}

extension IssueDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cell = tableView.cellForRow(at: indexPath) as? IssueDetailCellCommonHeight else {
            return 120
        }
        
        return CGFloat(cell.getHeight())
    }
}

extension IssueDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let entity = model?.getCellEntity(indexPath), let cellType = model?.getCellType(indexPath) else {
            return UITableViewCell()
        }
        
        var concreteCellType: UITableViewCell.Type
        
        switch cellType {
        case .separator:
            concreteCellType = IssueDetailTableViewCellSeparator.self
        case .info:
            concreteCellType = IssueDetailCommentTableViewCell.self
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: concreteCellType.reuseIdentifier, for: indexPath) as? IssueDetailCellCommonHeight else {
            return UITableViewCell()
        }
        
        cell.setEntity(entity)
        return cell as! UITableViewCell
    }
}
