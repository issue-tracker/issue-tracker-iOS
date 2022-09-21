//
//  LabelListViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/29.
//

import SnapKit
import UIKit
import RxSwift
import RxCocoa

class LabelListViewController: UIViewController, ViewBinding {
    
    private lazy var refreshControl = UIRefreshControl(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 20)))
    private var tableView = UITableView()
    private var disposeBag = DisposeBag()
    
    private var model: MainViewRequestModel<LabelListEntity>? = {
        guard let url = URL.labelApiURL else {
            return nil
        }
        
        return MainViewRequestModel(url)
    }()
    
    var modelStatusCount: String {
        if let entityList = model?.entityList {
            return "\(entityList.count)"
        }
        return "0"
    }
    
    private var entities: [LabelListEntity] {
        self.model?.entityList ?? []
    }
    
    lazy var bindableHandler: ((Any?, ViewBindable) -> Void)? = { [weak self] _, bindable in
        guard let self = self, bindable is MainViewRequestModel<LabelListEntity> else {
            return
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model?.binding = self
        
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        tableView.refreshControl = self.refreshControl
        refreshControl.addTarget(self, action: #selector(reloadTableView(_:)), for: .valueChanged)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.register(LabelListTableViewCell.self, forCellReuseIdentifier: LabelListTableViewCell.reuseIdentifier)
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        self.navigationController?.title = "0"
        
        model?.requestObservable()
            .asDriver(onErrorJustReturn: Data())
            .compactMap({ data -> [LabelListEntity]? in
                guard let result = HTTPResponseModel().getDecoded(from: data, as: [LabelListEntity].self) else {
                    return nil
                }
                
                self.navigationController?.title = "\(result.count)"
                return result
            })
            .drive(tableView.rx.items(cellIdentifier: LabelListTableViewCell.reuseIdentifier, cellType: LabelListTableViewCell.self)) { index, entity, cell in
                cell.setEntity(entity)
                cell.setLayout()
            }
            .disposed(by: disposeBag)
    }
    
    @objc func reloadTableView(_ sender: Any) {
        model?.requestIssueList() { [weak self] _, _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.tableView.refreshControl?.endRefreshing()
            }
        }
    }
}

extension LabelListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/8.5
    }
}
