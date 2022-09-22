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
    private var countOnDeparture = 0 {
        didSet {
            if countOnDeparture == 2 {
                DispatchQueue.main.async {
                    self.contentsTableView.reloadData()
                }
            }
        }
    }
    
    private(set) var model: IssueDetailViewModel?
    
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
        
        if let id = issueId {
            model = try? IssueDetailViewModel(issueId: id)
        }
        
        setEntity()
        
        contentsTableView.register(IssueDetailTableViewCellSeparator.self, forCellReuseIdentifier: IssueDetailTableViewCellSeparator.reuseIdentifier)
        contentsTableView.register(IssueDetailCommentTableViewCell.self, forCellReuseIdentifier: IssueDetailCommentTableViewCell.reuseIdentifier)
        
        view.addSubview(containerView)
        
        let isOpened = issueStatus == .open
        statusLabel.backgroundColor = (isOpened ? UIColor.green : UIColor.purple).withAlphaComponent(0.8)
        statusLabel.text = (isOpened ? "open" : "closed")
        
        additionalInfoScrollView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerView.flex.define { flex in
            // 고정값으로 처리하는 이유는 나중에도 layout을 다시 정의하도록 하기 때문.
            flex.addItem(additionalInfoView).height(60).direction(.row).padding(8).define { flex in
                flex.addItem(statusLabel).height(100%).aspectRatio(1).marginRight(4)
                flex.addItem(additionalInfoScrollView).grow(1)
            }
        }
        
        view.addSubview(contentsTableView)
        contentsTableView.snp.makeConstraints { make in
            make.top.equalTo(additionalInfoView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerView.layoutIfNeeded()
        containerView.flex.layout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func setEntity() {
        guard let model = self.model else { return }
        
        model.getDetailEntity()
            .subscribe(onNext: { entity in
                self.entity = entity
                DispatchQueue.main.async {
                    self.navigationItem.title = entity?.title
                }
            }, onCompleted: {
                self.countOnDeparture += 1
            })
            .disposed(by: model.bag)
        
        model.getEmojis()
            .subscribe(onNext: { [weak self] result in
                guard let emojis = result?.getEncodedEmojis() else { return }
                self?.model?.emojis = emojis
            }, onCompleted: {
                self.countOnDeparture += 1
            })
            .disposed(by: model.bag)
    }
}

extension IssueDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat(model?.getCellHeight(indexPath) ?? 120)
    }
}

extension IssueDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let entity = model?.getCellEntity(indexPath), let cellType = model?.getCellType(indexPath) else {
//            return UITableViewCell()
//        }
        
        guard let cellType = model?.getCellType(indexPath) else {
            return UITableViewCell()
        }
        
        var concreteCellType: UITableViewCell.Type
        
        switch cellType {
        case .separator:
            concreteCellType = IssueDetailTableViewCellSeparator.self
        case .info:
            concreteCellType = IssueDetailCommentTableViewCell.self
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: concreteCellType.reuseIdentifier, for: indexPath)
        
//        cell.setEntity(entity)
        (cell as? IssueDetailCommonType)?.setEntity(IssueListComment(id: indexPath.row, author: IssueListAuthor(id: indexPath.row, email: "authorEmail", nickname: "authornickname", profileImage: UserDefaults.standard.string(forKey: "profileImage") ?? ""), content: "commentContent", createdAt: "long long days ago", issueCommentReactionsResponse: []))
        return cell as UITableViewCell
    }
}
