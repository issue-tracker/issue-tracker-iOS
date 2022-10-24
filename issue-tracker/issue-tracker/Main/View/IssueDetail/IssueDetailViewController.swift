//
//  IssueDetailViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/08.
//

import UIKit
import SnapKit
import FlexLayout
import RxSwift

enum IssueStatus {
    case open
    case closed
}

class IssueDetailViewController: CommonProxyViewController {
    
    private var issueId: Int?
    private var entity: IssueListEntity?
    private var issueStatus: IssueStatus = .closed
    
    private(set) var model: IssueDetailViewModel?
    
    convenience init(_ id: Int, status: IssueStatus) {
        self.init()
        self.issueId = id
        self.issueStatus = status
    }
    
    private let containerView = UIView()
    
    private let additionalInfoView = UIView()
    private lazy var statusLabel: CommonLabel = {
        let label = CommonLabel(fontMultiplier: 0.9)
        let isOpened = issueStatus == .open
        let statusColor = isOpened ? UIColor.green : UIColor.purple
        
        label.textColor = statusColor
        label.backgroundColor = statusColor.withAlphaComponent(0.3)
        label.text = (isOpened ? "open" : "closed")
        label.setCornerRadius()
        
        return label
    }()
    private let additionalInfoScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.backgroundColor = .lightGray
        scrollView.setCornerRadius()
        return scrollView
    }()
    
    private lazy var contentsTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .opaqueSeparator
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = issueId {
            model = try? IssueDetailViewModel(issueId: id)
        }
        
        view.addSubview(containerView)
        
        additionalInfoScrollView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerView.flex.define { flex in
            // 고정값으로 처리하는 이유는 나중에도 layout을 다시 정의하도록 하기 때문.
            flex.addItem(additionalInfoView).height(30).direction(.row).padding(8).define { flex in
                flex.addItem(statusLabel).height(100%).aspectRatio(1).marginRight(4)
                flex.addItem(additionalInfoScrollView).grow(1)
            }
        }
        
        contentsTableView.register(IssueDetailTableViewCellSeparator.self, forCellReuseIdentifier: IssueDetailTableViewCellSeparator.reuseIdentifier)
        contentsTableView.register(IssueDetailCommentTableViewCell.self, forCellReuseIdentifier: IssueDetailCommentTableViewCell.reuseIdentifier)
        view.addSubview(contentsTableView)
        
        contentsTableView.snp.makeConstraints { make in
            make.top.equalTo(additionalInfoView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerView.layoutIfNeeded()
        containerView.flex.layout()
        
        setEntity()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func setEntity() {
        guard let model = self.model else { return }
        
        model.getDetailEntity()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] entity in
                self?.navigationItem.title = entity?.title
                self?.contentsTableView.reloadData()
            })
            .disposed(by: model.bag)
        
        model.getEmojis()
            .subscribe(onNext: { [weak self] result in
                self?.model?.emojis = result?.getEncodedEmojis() ?? []
            })
            .disposed(by: model.bag)
    }
}

extension IssueDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let heightFloat = model?.getCellHeight(indexPath) else {
            return 120
        }
        
        return CGFloat(heightFloat)
    }
}

extension IssueDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.contentsCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let entity = model?.getCellEntity(indexPath) else {
            return UITableViewCell()
        }
        
        switch entity.cellType {
        case .separator:
            typealias CELL = IssueDetailTableViewCellSeparator
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL.reuseIdentifier, for: indexPath) as? CELL
            cell?.setEntity(entity)
            return cell ?? UITableViewCell()
        case .info:
            typealias CELL = IssueDetailCommentTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL.reuseIdentifier, for: indexPath) as? CELL
            cell?.setEntity(entity)
            return cell ?? UITableViewCell()
        }
    }
}
