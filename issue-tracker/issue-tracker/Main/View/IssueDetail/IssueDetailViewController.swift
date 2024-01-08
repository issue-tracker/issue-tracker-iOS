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

class IssueDetailViewController: CommonProxyViewController {
    
    private var issueId: Int?
    
    private(set) var model: IssueDetailViewModel?
    
    convenience init(_ id: Int) {
        self.init()
        self.issueId = id
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    private lazy var issuePathLabel: CommonLabel = {
        let label = CommonLabel(fontMultiplier: 0.8)
        label.textAlignment = .left
        label.text = "issue"
        label.setId(issueId)
        return label
    }()
    private let titleLabel: CommonLabel = {
        let label = CommonLabel(fontMultiplier: 1.2)
        label.textAlignment = .left
        return label
    }()
    private let additionalInfoScrollView: QueryBookmarkScrollView = {
        let scrollView = QueryBookmarkScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
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
        tabBarController?.tabBar.isHidden = true
        navigationItem.title = ""
        view.backgroundColor = .systemBackground
        if let id = issueId {
            model = try? IssueDetailViewModel(issueId: id)
        }
        contentsTableView.register(IssueDetailTableViewCellSeparator.self, forCellReuseIdentifier: IssueDetailTableViewCellSeparator.reuseIdentifier)
        contentsTableView.register(IssueDetailCommentTableViewCell.self, forCellReuseIdentifier: IssueDetailCommentTableViewCell.reuseIdentifier)
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerView.flex.alignSelf(.stretch).define { flex in
            flex.addItem(issuePathLabel).height(20).marginHorizontal(8).marginVertical(16)
            flex.addItem(titleLabel).minHeight(40).marginHorizontal(8).marginBottom(10)
            flex.addItem(additionalInfoScrollView).height(20).marginHorizontal(8).marginBottom(16)
            flex.addItem().backgroundColor(UIColor.separator).height(10)
            flex.addItem(contentsTableView).grow(1)
        }
        
        view.layoutIfNeeded()
        containerView.flex.layout()
        
        additionalInfoScrollView.setCornerRadius()
        
        setEntity()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setEntity() {
        guard let model = self.model else { return }
        
        model.getDetailEntity()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] entity in
                self?.setTitleArea()
                self?.setAdditionalInfo()
                self?.contentsTableView.reloadData()
            })
            .disposed(by: model.bag)
        
        model.getEmojis()
    }
    
    private func setTitleArea() {
        guard let entity = model?.issueDetail else { return }
        
        titleLabel.text = entity.title
        issuePathLabel.setId(entity.id)
    }
    
    private func setAdditionalInfo() {
        guard let entity = model?.issueDetail else { return }
        
        additionalInfoScrollView.subviews.forEach { $0.removeFromSuperview() }
        let status = additionalInfoScrollView.insertNormalButton(text: entity.closed ? "closed" : "open")
        status?.backgroundColor = entity.closed ? .green.withAlphaComponent(0.3) : .opaqueSeparator
        status?.setCornerRadius()
        
        for label in entity.issueLabels {
            let button = additionalInfoScrollView.insertNormalButton(text: label.title)
            button?.backgroundColor = UIColor.init(hex: label.backgroundColorCode)
            button?.setCornerRadius()
        }
        
        additionalInfoScrollView.setNeedsDisplay()
    }
}

extension IssueDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightFloat = model?.getCellHeight(indexPath) ?? 120
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

private extension CommonLabel {
    /// set Id after path defined.
    func setId(_ issueId: Int?) {
        if let shopIndex = self.text?.firstIndex(of: "#") {
            self.text?.removeSubrange(shopIndex...)
        }
        
        guard let issueId = issueId, var text = self.text, text.count > 0 else { return }
        
        let id = "#" + String(issueId)
        text += id
        let range = NSRange(location: 0, length: text.count-2)
        let str = NSMutableAttributedString(string: text)
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.separator, range: range)
        self.text = str.string
    }
}
