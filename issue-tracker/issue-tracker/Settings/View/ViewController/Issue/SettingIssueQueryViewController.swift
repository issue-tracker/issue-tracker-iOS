//
//  SettingIssueQueryViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/07.
//

import FlexLayout
import RxSwift
import RxCocoa
import Foundation

/// UITableView EditMode 이용해서 적용할 쿼리와 적용하지 않을 쿼리를 설정할 수 있도록 함.
///
/// 삭제 추가가 가능하게 해야할지는 잘 모르겠음.
class SettingIssueQueryViewController: UIViewController {
    private let padding: CGFloat = 8
    
    private let activationTableView = UITableView()
    private let deActivationTableView = UITableView()
    private var disposeBag = DisposeBag()
    
    private let model = SettingIssueQueryModel.init(key: IssueSettings.query)
    
    lazy var addQuerySubject = PublishRelay<SettingIssueQueryItem>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Query"
        
        activationTableView.rowHeight = 50
        deActivationTableView.rowHeight = 50
        
        view.flex.define { flex in
            flex.addItem(activationTableView).height(50%)
            flex.addItem(deActivationTableView).height(50%)
        }
        view.flex.layout()
        
        typealias CELL = SettingIssueQueryCell
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: UIAction(handler: { [weak self] _ in
            let popup = SettingQueryInsertView(self?.addQuerySubject)
            popup.modalPresentationStyle = .formSheet
            self?.present(popup, animated: true)
        }))
        
        addQuerySubject
            .subscribe(onNext: { [weak self] entity in
                self?.model.addItem(entity)
            })
            .disposed(by: disposeBag)
        
        activationTableView.register(CELL.self, forCellReuseIdentifier: CELL.reuseIdentifier)
        deActivationTableView.register(CELL.self, forCellReuseIdentifier: CELL.reuseIdentifier)
        
        activationTableView.delegate = self
        activationTableView.setEditing(true, animated: false)
        activationTableView.rx.itemMoved
            .bind(onNext: { [weak self] info in
                self?.model.swapActiveItem(from: info.sourceIndex.row, to: info.destinationIndex.row)
            })
            .disposed(by: disposeBag)
        model.activeEntityRelay
            .bind(to: activationTableView.rx.items(cellIdentifier: CELL.reuseIdentifier, cellType: CELL.self)) { index, entity, cell in
                cell.setEntity(entity)
            }
            .disposed(by: disposeBag)
        
        deActivationTableView.delegate = self
        deActivationTableView.setEditing(true, animated: false)
        deActivationTableView.rx.itemMoved
            .bind(onNext: { [weak self] info in
                self?.model.swapDeActiveItem(from: info.sourceIndex.row, to: info.destinationIndex.row)
            })
            .disposed(by: disposeBag)
        model.deActiveEntityRelay
            .bind(to: deActivationTableView.rx.items(cellIdentifier: CELL.reuseIdentifier, cellType: CELL.self)) { index, entity, cell in
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
    
    private(set) var activatedEntities = [Item]() {
        didSet {
            self.activeEntityRelay.accept(activatedEntities)
        }
    }
    private(set) var deActivatedEntities = [Item]() {
        didSet {
            self.deActiveEntityRelay.accept(deActivatedEntities)
        }
    }
    
    var activeEntityRelay = BehaviorRelay<[Item]>(value: [])
    var deActiveEntityRelay = BehaviorRelay<[Item]>(value: [])
    private(set) var onMovedSubject = PublishSubject<Item>()
    
    private var disposeBag = DisposeBag()
    
    init(key: PersistentKey) {
        self.keyType = key
        
        onMovedSubject
            .subscribe(onNext: { self.setItemOn($0)})
            .disposed(by: disposeBag)
        
        if let key = keyType {
            if let data = UserDefaults.standard.object(forKey: key.getPersistentKey()) as? Data {
                let allData = decoded(data)
                
                activatedEntities = allData.filter({$0.isOn})
                deActivatedEntities = allData.filter({$0.isOn == false})
                
                activeEntityRelay.accept(activatedEntities)
                deActiveEntityRelay.accept(deActivatedEntities)
            }
        }
    }
    
    func setItemOn(_ item: Item) { // 도착점에 표시해주어야 할 Item. Id 는 같음.
        
        var targetQueries = item.isOn ? activatedEntities : deActivatedEntities // 도착점은 item 이 활성상태를 가리키는지 보면 됨.
        var startingQueries = activatedEntities.contains(item) ? activatedEntities : deActivatedEntities // 시작점은 기존 item의 id 를 가진 배열을 찾으면 됨.
        
        if let index = targetQueries.firstIndex(of: item) { // 타겟에서 이미 찾음. 둘의 위치만 바꿈.
            targetQueries.swapAt(item.index, index)
            
            if item.isOn {
                activatedEntities = targetQueries
            } else {
                deActivatedEntities = targetQueries
            }
            
        } else { // 못 찾으면 시작점들에서 삭제하고 지정된 인덱스에 추가한다.
            if let previousIndex = startingQueries.firstIndex(of: item) {
                startingQueries.remove(at: previousIndex)
            }
            
            targetQueries.insert(item, at: item.index)
            
            if item.isOn { // item 이 비활성 -> 활성으로 변함
                activatedEntities = targetQueries
                deActivatedEntities = startingQueries
            } else {
                activatedEntities = startingQueries
                deActivatedEntities = targetQueries
            }
        }
        
        activeEntityRelay.accept(activatedEntities)
        deActiveEntityRelay.accept(deActivatedEntities)
    }
    
    func setItemOn(key: String, isOn: Bool, at: Int) { // 도착점에 표시해주어야 할 Item. Id 는 같음.
        var item = activatedEntities.first(where: {$0.id.uuidString == key}) ?? deActivatedEntities.first(where: {$0.id.uuidString == key})
        item?.isOn = isOn
        
        guard let item = item else {
            return
        }
        
        setItemOn(item)
    }
    
    func getActiveItem(at index: Int) -> SettingIssueQueryItem? {
        guard 0..<activatedEntities.count ~= index else {
            return nil
        }
        
        return activatedEntities[index]
    }
    
    @discardableResult
    func swapActiveItem(from fromIndex: Int, to toIndex: Int) -> Bool {
        guard 0..<activatedEntities.count ~= fromIndex, 0..<activatedEntities.count ~= toIndex else {
            return false
        }
        
        activatedEntities.swapAt(fromIndex, toIndex)
        return true
    }
    
    @discardableResult
    func swapDeActiveItem(from fromIndex: Int, to toIndex: Int) -> Bool {
        guard 0..<deActivatedEntities.count ~= fromIndex, 0..<deActivatedEntities.count ~= toIndex else {
            return false
        }
        
        deActivatedEntities.swapAt(fromIndex, toIndex)
        return true
    }
    
    func getDeActiveItem(at index: Int) -> SettingIssueQueryItem? {
        guard 0..<deActivatedEntities.count ~= index else {
            return nil
        }
        
        return deActivatedEntities[index]
    }
    
    func dragItem(isActiveTableView: Bool, at index: Int) -> [NSItemProvider] {
        let item = isActiveTableView ? getActiveItem(at: index) : getDeActiveItem(at: index)
        let data = item?.id.uuidString.data(using: .utf8)
        let itemProvider = NSItemProvider()
        
        itemProvider.registerDataRepresentation(forTypeIdentifier: "data", visibility: .all) { completion in
            completion(data, nil)
            return nil
        }
        
        return [itemProvider]
    }
    
    @discardableResult
    func addItem(_ item: SettingIssueQueryItem) -> Bool {
        self.activatedEntities.append(item)
        return true
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
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(label)
        
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setEntity(_ entity: SettingIssueQueryItem) {
        label.text = entity.query
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
