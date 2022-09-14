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
        label.setCornerRadius()
        label.textColor = .secondaryLabel
        return label
    }()
    private let additionalInfoScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.backgroundColor = .lightGray
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
        
        navigationItem.backButtonTitle = ""
        containerView.backgroundColor = .yellow
        
        let isOpened = issueStatus == .open
        statusLabel.backgroundColor = (isOpened ? UIColor.green : UIColor.purple).withAlphaComponent(0.8)
        statusLabel.text = (isOpened ? "open" : "closed")
        
        containerView.flex.define { flex in
            flex.addItem(additionalInfoView).height(12%).direction(.row).define { flex in
                flex.addItem(statusLabel).width(25%).alignItems(.center).padding(8)
                flex.addItem(additionalInfoScrollView).width(75%).padding(UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 8))
            }
            flex.addItem().height(8%)
            flex.addItem(contentsTableView).minHeight(70%)
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerView.layoutIfNeeded()
        containerView.flex.layout()
    }
    
    func setEntity() {
        guard let id = issueId, let model = IssueDetailViewModel(issueId: id) else {
            return
        }
        
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
                        for emoji in emojis {
                            let label = UILabel(frame: CGRect(
                                origin: .zero,
                                size: CGSize(width: scrollView.frame.height, height: scrollView.frame.height))
                            )
                            
                            label.text = emoji
                            
                            scrollView.flex.direction(.row).addItem(label)
                            scrollView.flex.layout()
                            scrollView.reloadContentSizeWidth()
                        }
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
        80
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
