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
    
    typealias MODEL = MainViewSingleRequestModel<AllIssueEntity, IssueListEntity>
    
    private lazy var refreshControl = UIRefreshControl(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 20)))
    private var tableView = UITableView()
    private var disposeBag = DisposeBag()
    
    private var model: MODEL? = {
        guard let url = URL.issueApiURL else {
            return nil
        }
        
        return MODEL(url)
    }()
    var modelStatusCount: String {
        if let entity = model?.entity {
            return "\(entity.openIssueCount)/\(entity.openIssueCount+entity.closedIssueCount)"
        }
        return "0/0"
    }
    
    private var issues: [IssueListEntity] {
        model?.entityList ?? []
    }
    
    var binding: ViewBinding?
    
    lazy var bindableHandler: ((Any?, ViewBindable) -> Void)? = { [weak self] queryPath, bindable in
        guard let self = self else { return }
        
        if bindable is MODEL {
            self.binding?.bindableHandler?(self.model?.entity, self)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model?.binding = self
        
        tableView.accessibilityIdentifier = "issueListViewController"
        
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
        
        model?.dataSource
            .asDriver(onErrorJustReturn: [])
            .do(onNext: { [weak self] _ in
                self?.navigationController?.title = self?.modelStatusCount
            })
            .drive(tableView.rx.items(cellIdentifier: IssueListTableViewCell.reuseIdentifier, cellType: IssueListTableViewCell.self)) { index, entity, cell in
                cell.setEntity(entity)
                cell.setLayout()
            }
            .disposed(by: model?.disposeBag ?? disposeBag)
                
        model?.requestEntity()
    }
    
    func setQueryPath(_ queryPath: String) {
        model?.issueQueryPath = queryPath
        model?.reloadEntities()
    }
    
    @objc func reloadTableView(_ sender: Any) {
        model?.issueQueryPath = nil
        model?.reloadEntities(reloadHandler: { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.tableView.refreshControl?.endRefreshing()
            }
        })
    }
}

extension IssueListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/4.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        binding?.bindableHandler?(issues[indexPath.row], self)
    }
}

extension IssueListViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if canResignFirstResponder {
            (binding as? MainListViewController)?.searchBar.resignFirstResponder()
        }
    }
}
