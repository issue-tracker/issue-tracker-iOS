//
//  MainListViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2024/01/09.
//

import UIKit
import ReactorKit
import RxCocoa

class MainListViewController<M>: UIViewController, View where M: Codable, M: MainListEntity {
    
    typealias Reactor = MainListReactor<M>
    var disposeBag = DisposeBag()
    private(set) var listType: MainContainerViewController.MainListType
    private(set) var listItemRelay: PublishRelay<Int>
    var cellType: UITableViewCell.Type {
        listType.cellMetaType
    }
    
    private var refreshControl = UIRefreshControl(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
    private(set) var tableView = UITableView()
    
    private var statusDescription: String = ""
    private var container: MainContainerViewController? {
        parent as? MainContainerViewController
    }
    
    init(relay: PublishRelay<Int>, type: MainContainerViewController.MainListType) {
        self.listItemRelay = relay
        self.listType = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = Reactor()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if let vc = parent as? MainContainerViewController {
            view.frame.size = vc.listScrollView.frame.size
            tableView.rowHeight = vc.listScrollView.frame.height / 4.5
        }
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bind(reactor: MainListReactor<M>) {
        // Local Views
        refreshControl.rx
            .controlEvent(.editingDidBegin)
            .timeout(.seconds(2), scheduler: MainScheduler.instance)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak reactor] _ in
                reactor?.action.onNext(.reloadList)
            } onError: { [weak refreshControl] _ in
                refreshControl?.endRefreshing()
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$listStatus)
            .filter({ [weak container] _ in container?.listSegmentedControl.selectedSegmentIndex == 0 })
            .asDriver(onErrorJustReturn: reactor.currentState.listStatus)
            .drive(onNext: { [weak self] title in
                self?.refreshControl.endRefreshing()
                self?.container?.title = title
            })
            .disposed(by: disposeBag)
        
        // TableView Initialize
        tableView.rx.itemSelected
            .compactMap { [weak reactor] indexPath -> Int? in
                reactor?.currentState.list[indexPath.row].info.id
            }
            .subscribe(onNext: { [weak listItemRelay] id in
                listItemRelay?.accept(id)
            })
            .disposed(by: disposeBag)
    }
}

class MainListReactor<M>: Reactor where M: Codable, M: MainListEntity {
    var initialState: State = .init()
    
    enum Action {
        case reloadList, fetchList
    }
    
    enum Mutation {
        /// list & isAppending
        case setList([M], Bool)
    }
    
    struct State {
        @Pulse var list: [M] = [
            .init(inx: 0), .init(inx: 1), .init(inx: 2), .init(inx: 3), .init(inx: 4)
        ]
        @Pulse var listStatus: String = "0"
        var pageNumber = 0
    }
}

struct MainListInfo: Codable {
    let id: Int
    let title: String
    let contents: String
    
    let createdAt: String?
    let lastModifiedAt: String?
    let closed: Bool
    
    init(id: Int, title: String, contents: String, createdAt: String?, lastModifiedAt: String?, closed: Bool) {
        self.id = id
        self.title = title
        self.contents = contents
        self.createdAt = createdAt
        self.lastModifiedAt = lastModifiedAt
        self.closed = closed
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.contents = try container.decode(String.self, forKey: .contents)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        self.lastModifiedAt = try container.decodeIfPresent(String.self, forKey: .lastModifiedAt)
        self.closed = try container.decode(Bool.self, forKey: .closed)
    }
    
    enum CodingKeys: CodingKey {
        case id, title, contents, createdAt, lastModifiedAt, closed
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.contents, forKey: .contents)
        try container.encodeIfPresent(self.createdAt, forKey: .createdAt)
        try container.encodeIfPresent(self.lastModifiedAt, forKey: .lastModifiedAt)
        try container.encode(self.closed, forKey: .closed)
    }
}

protocol MainListCell {
    func setLayout()
    func setEntity(_ entity: MainListEntity)
    func makeUI()
}

protocol MainListEntity {
    var info: MainListInfo { get }
    init(inx: Int)
}
