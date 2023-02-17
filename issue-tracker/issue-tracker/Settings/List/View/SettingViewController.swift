//
//  SettingViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import ReactorKit

fileprivate typealias CELL = SettingTableViewCell
fileprivate typealias TITLECELL = SettingTableViewTitleCell

class SettingViewController: CommonProxyViewController, View {
    typealias Reactor = SettingReactor
    
    var navigationBarTitle: String?
    var disposeBag = DisposeBag()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    let headerSectionButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor.opaqueSeparator
        view.isHidden = true
        view.setTitle("<", for: .normal)
        view.accessibilityIdentifier = "BackButton"
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.register(TITLECELL.self, forCellReuseIdentifier: TITLECELL.reuseIdentifier)
        view.register(CELL.self, forCellReuseIdentifier: CELL.reuseIdentifier)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        view.addSubview(stackView)
        
        headerSectionButton.frame.size.height = 90
        stackView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        stackView.addArrangedSubview(headerSectionButton)
        stackView.addArrangedSubview(tableView)
        
        reactor = Reactor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let title = navigationItem.title, title.hasPrefix("Setting") == false {
            navigationItem.title = navigationBarTitle
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationBarTitle = navigationItem.title
    }
    
    func bind(reactor: SettingReactor) {
        tableView.rx.itemSelected
            .compactMap({ [weak self] indexPath in
                self?.reactor?.currentState.currentItem(at: indexPath)
            })
            .filter({ [weak self] (item) -> Bool in
                guard let selectedItem = item as? SettingListItem else {
                    return true
                }
                
                self?.goNextView(selectedItem)
                return false
            })
            .do(onNext: { [weak self] item in
                guard let title = self?.reactor?.getListTitle(item) else {
                    return
                }
                
                self?.navigationItem.title?.append(contentsOf: "-\(title)")
            })
            .bind(onNext: { [weak self] item in
                var action: Reactor.Action? {
                    if let category = item as? SettingCategory {
                        return .selectCategory(category)
                    } else if let list = item as? SettingList {
                        return .selectList(list)
                    }
                    
                    return nil
                }
                
                if let action {
                    self?.reactor?.action.onNext(action)
                }
            })
            .disposed(by: disposeBag)
        
        headerSectionButton.rx.tap
            .bind(onNext: {
                if let removeStartIndex = self.navigationItem.title?.lastIndex(of: "-") {
                    self.navigationItem.title?.removeSubrange(removeStartIndex...)
                } else {
                    self.navigationItem.title = "Settings"
                }
                
                switch self.reactor?.currentState.settingListType {
                case .list:
                    self.reactor?.action.onNext(.backToCategory)
                case .item:
                    self.reactor?.action.onNext(.backToList)
                default:
                    return
                }
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$settingTableViewList)
            .observe(on: MainScheduler.asyncInstance)
            .do(onNext: { [weak self] items in
                if let reactor = self?.reactor {
                    let listCount = reactor.currentState.getListCount()
                    self?.tableView.performBatchUpdates({
                        let indexPaths = (0..<listCount).map({
                            IndexPath(row: $0, section: 0)
                        })
                        
                        self?.tableView.reloadRows(at: indexPaths, with: .left)
                    })
                }
                
                if let type = items.first?.type {
                    self?.reactor?.action.onNext(.sendListType(type))
                }
            })
            .bind(to: tableView.rx.items(
                cellIdentifier: CELL.reuseIdentifier,
                cellType: CELL.self)
            ) { [weak self] _, element, cell in
                
                self?.headerSectionButton.isHidden = element.isCategory
                cell.label.text = element.title
            }
            .disposed(by: disposeBag)
    }
    
    private func goNextView(_ item: SettingListItem) {
        let view = SettingDetailViewController()
        view.settingItem = item
        navigationController?.pushViewController(view, animated: true)
    }
}
