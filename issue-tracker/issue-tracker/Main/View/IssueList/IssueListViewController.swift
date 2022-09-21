//
//  IssueListViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/20.
//

import SnapKit
import RxSwift
import RxCocoa

class IssueListViewController: UIViewController, ViewBinding, ViewBindable {
    
    private lazy var refreshControl = UIRefreshControl(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 20)))
    private var tableView = UITableView()
    private var disposeBag = DisposeBag()
    
    private var model: MainViewSingleRequestModel<AllIssueEntity>? = {
        guard let url = URL.issueApiURL else {
            return nil
        }
        
        return MainViewSingleRequestModel(url)
    }()
    var modelStatusCount: String {
        if let entity = model?.entity {
            return "\(entity.openIssues.count)/\(entity.openIssues.count+entity.closedIssues.count)"
        }
        return "0/0"
    }
    
    private var openIssues: [IssueListEntity] {
        model?.entity?.openIssues ?? []
    }
    private var closedIssues: [IssueListEntity] {
        model?.entity?.closedIssues ?? []
    }
    private var allIssues: [IssueListEntity] {
        openIssues + closedIssues
    }
    
    var binding: ViewBinding?
    
    lazy var bindableHandler: ((Any?, ViewBindable) -> Void)? = { [weak self] _, bindable in
        guard let self = self, bindable is MainViewSingleRequestModel<AllIssueEntity> else {
            return
        }
        
        self.binding?.bindableHandler?(self.model?.entity, self)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model?.binding = self
        model?.builder.setURLQuery(["page":"0"])
        
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        tableView.refreshControl = self.refreshControl
        refreshControl.addTarget(self, action: #selector(reloadTableView(_:)), for: .valueChanged)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.register(IssueListTableViewCell.self, forCellReuseIdentifier: IssueListTableViewCell.reuseIdentifier)
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        model?.requestObservable()
            .asDriver(onErrorJustReturn: Data())
            .compactMap({ data -> AllIssueEntity? in
                HTTPResponseModel().getDecoded(from: data, as: AllIssueEntity.self)
            })
            .map({ entities -> [IssueListEntity] in
                self.navigationController?.title = "\(entities.openIssues.count)/\((entities.openIssues + entities.closedIssues).count)"
                return entities.openIssues + entities.closedIssues
            })
            .drive(tableView.rx.items(cellIdentifier: IssueListTableViewCell.reuseIdentifier, cellType: IssueListTableViewCell.self)) { index, entity, cell in
                cell.setEntity(entity)
                cell.setLayout()
            }
            .disposed(by: disposeBag)
    }
    
    @objc func reloadTableView(_ sender: Any) {
        model?.requestEntities() { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.tableView.refreshControl?.endRefreshing()
            }
        }
    }
}

extension IssueListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/4.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        binding?.bindableHandler?(allIssues[indexPath.row], self)
    }
}
