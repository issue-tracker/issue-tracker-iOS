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
        let cellSelected = tableView.rx.itemSelected.share()
        
        let settingCellSelected = cellSelected
            .compactMap { self.reactor?.currentState.currentItem(at: $0) }
        
        let emitCellTitle = settingCellSelected
            .compactMap({ $0 as? SettingListCellTitle })
        
        let emitSettingItem = settingCellSelected
            .compactMap { $0 as? SettingListItem }
        
        cellSelected
            .bind { self.tableView.deselectRow(at: $0, animated: false) }
            .disposed(by: disposeBag)
        
        settingCellSelected
            .bind { item in
                if let category = item as? SettingCategory {
                    self.reactor?.action.onNext(.selectCategory(category))
                } else if let list = item as? SettingList {
                    self.reactor?.action.onNext(.selectList(list))
                }
            }
            .disposed(by: disposeBag)
        
        emitCellTitle
            .bind {
                guard var titleLabelText = $0.mainTitle else { return }
                self.reactor?.truncateString(&titleLabelText)
                self.navigationItem.title?.append(contentsOf: "-\(titleLabelText)")
            }
            .disposed(by: disposeBag)
        
        emitSettingItem
            .bind { [weak self] in self?.goNextView($0) }
            .disposed(by: disposeBag)
        
        headerSectionButton.rx.tap
            .bind(onNext: {
                if let removeStartIndex = self.navigationItem.title?.lastIndex(of: "-") {
                    self.navigationItem.title?.removeSubrange(removeStartIndex...)
                } else {
                    self.navigationItem.title = "Setting"
                }
                
                let listType = self.reactor?.currentState.settingListType
                let reactorAction = self.reactor?.action
                
                switch listType {
                case .list: reactorAction?.onNext(.backToCategory)
                case .item: reactorAction?.onNext(.backToList)
                default: return
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
