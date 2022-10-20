//
//  SettingIssueQueryViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/07.
//

import SnapKit
import RxSwift
import RxCocoa
import Foundation

/// UITableView EditMode 이용해서 적용할 쿼리와 적용하지 않을 쿼리를 설정할 수 있도록 함.
///
/// 삭제 추가가 가능하게 해야할지는 잘 모르겠음.
class SettingIssueQueryViewController: UIViewController {
    private let padding: CGFloat = 8
    
    private let tableView = UITableView()
    private var disposeBag = DisposeBag()
    
    private let model = SettingIssueQueryModel.init(key: IssueSettings.query)
    
    let addQuerySubject = PublishRelay<SettingIssueQueryItem>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Query"
        view.addSubview(tableView)
        
        tableView.rowHeight = 50
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        typealias CELL = SettingIssueQueryCell
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: UIAction(handler: { [weak self] _ in
            self?.present(SettingQueryInsertView(self?.addQuerySubject), animated: true)
        }))
        
        addQuerySubject
            .subscribe(onNext: { [weak self] entity in
                self?.model.addEntity(entity)
            })
            .disposed(by: disposeBag)
        
        tableView.register(CELL.self, forCellReuseIdentifier: CELL.reuseIdentifier)
        tableView.delegate = self
        tableView.setEditing(true, animated: false)
        tableView.rx.itemMoved
            .bind(onNext: { [weak self] info in
                self?.model.swapEntities(from: info.sourceIndex.row, to: info.destinationIndex.row)
            })
            .disposed(by: disposeBag)
        model.entitiesRelay
            .bind(to: tableView.rx.items(cellIdentifier: CELL.reuseIdentifier, cellType: CELL.self)) { _, entity, cell in
                cell.setEntity(entity)
            }
            .disposed(by: disposeBag)
    }
}

extension SettingIssueQueryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
}

final class SettingIssueQueryModel {
    typealias Item = SettingIssueQueryItem
    
    private var keyType: PersistentKey?
    
    let entitiesRelay = BehaviorRelay<[Item]>(value: [])
    let onMovedSubject = PublishSubject<Item>()
    private var disposeBag = DisposeBag()
    private(set) var entities = [Item]() {
        didSet {
            self.entitiesRelay.accept(entities)
        }
    }
    
    init(key: PersistentKey) {
        keyType = key
        if let data = UserDefaults.standard.object(forKey: key.getPersistentKey()) as? Data {
            let entities = decoded(data)
            self.entities = entities
            entitiesRelay.accept(entities)
        }
        
        onMovedSubject
            .subscribe(onNext: { self.setItemOn($0) })
            .disposed(by: disposeBag)
    }
    
    /// - Parameters:
    ///     - item: 새로 추가되어야 할 아이템.
    func setItemOn(_ entity: Item) {
        guard let previousItem = entities.first(where: {$0 == entity}) else { return }
        
        if entity.index != previousItem.index {
            guard swapEntities(from: previousItem.index, to: entity.index) else { return }
        }
        
        entities[entity.index] = entity
    }
    
    /// 위치와 상태만 바꾸고 싶을 때
    ///
    /// - Parameters:
    ///     - key: 변경해야 할 아이템의 키
    ///     - isOn: 활성화 상태
    ///     - at: index
    func setItemOn(key: String, isOn: Bool, at: Int) { // 도착점에 표시해주어야 할 Item. Id 는 같음.
        var item = entities.first(where: {$0.id.uuidString == key})
        item?.isOn = isOn
        
        guard let item = item else { return }
        setItemOn(item)
    }
    
    func getEntity(at index: Int) -> SettingIssueQueryItem? {
        guard 0..<entities.count ~= index else { return nil }
        return entities[index]
    }
    
    @discardableResult
    func swapEntities(from fromIndex: Int, to toIndex: Int) -> Bool {
        guard 0..<entities.count ~= fromIndex, 0..<entities.count ~= toIndex else { return false }
        entities.swapAt(fromIndex, toIndex)
        return true
    }
    
    func addEntity(_ entity: SettingIssueQueryItem) {
        entities.append(entity)
    }
}

extension SettingIssueQueryModel {
    func decoded(_ data: Data) -> [SettingIssueQueryItem] {
        (try? JSONDecoder().decode([Item].self, from: data)) ?? []
    }
    
    func encoded(_ list: [SettingIssueQueryItem]) -> Data {
        (try? JSONEncoder().encode(list)) ?? Data()
    }
}

final class SettingIssueQueryCell: UITableViewCell {
    let label = CommonLabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    private func makeUI() {
        contentView.addSubview(label)
        backgroundColor = .systemBackground
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setEntity(_ entity: SettingIssueQueryItem) {
        label.text = entity.query
        
        let queryStatus: QueryStatusColor = entity.isOn ? .activeColor : .deActiveColor
        backgroundColor = queryStatus.getColor()
    }
}

struct SettingIssueQueryItem: Codable, Equatable {
    var id: UUID = UUID()
    var query: String
    var isOn: Bool = false
    var index: Int = 0
    
    static func == (lhs: SettingIssueQueryItem, rhs: SettingIssueQueryItem) -> Bool {
        return lhs.id == rhs.id
    }
}

enum QueryStatusColor {
    case activeColor
    case deActiveColor
    
    func getColor() -> UIColor? {
        switch self {
        case .activeColor:
            return UIColor(named: "query_status_active")
        case .deActiveColor:
            return UIColor(named: "query_status_deactive")
        }
    }
}
