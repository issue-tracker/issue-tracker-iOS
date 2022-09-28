//
//  PopupTableView.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/28.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class PopupTableView: UIView, ViewBindable {
    
    private var observer: NSObjectProtocol?
    
    private var tableView = UITableView()
    private var cellTitles = [String]()
    
    var binding: ViewBinding?
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
        addShadow()
        setNotification()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
        addShadow()
        setNotification()
    }
    
    convenience init(
        frame: CGRect,
        identifierAccessibility: String? = nil,
        @PopupTableVeiwBuilder _ content: () -> [String],
        _ completionHandler: (()->Void)? = nil
    ) {
        self.init(frame: frame)
        self.accessibilityIdentifier = identifierAccessibility
        self.cellTitles = content()
    }
    
    private func makeUI() {
        addSubview(tableView)
        setCornerRadius(2)
        
        tableView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(8)
            $0.trailing.bottom.equalToSuperview().offset(8)
        }
        
        layoutIfNeeded()
    }
    
    private func addShadow() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = layer.cornerRadius
        layer.shadowOffset = .zero
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
    
    func initialSetting() {
        disposeBag = DisposeBag()
        
        tableView.rowHeight = 50
        tableView.register(PopupTableViewCell.self, forCellReuseIdentifier: PopupTableViewCell.reuseIdentifier)
        
        Observable<[String]>
            .just(cellTitles)
            .bind(to: tableView.rx.items(cellIdentifier: PopupTableViewCell.reuseIdentifier, cellType: PopupTableViewCell.self)) { index, title, cell in
                cell.contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
                cell.titleLabel.text = title
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] event in
                guard let self = self else { return }
                let selectedTitle = self.cellTitles[event.item]
                self.binding?.bindableHandler?(selectedTitle, self)
                
                UIView.animate(withDuration: 0.3) {
                    self.layer.opacity = 0
                } completion: { _ in
                    self.removeFromSuperview()
                }

            })
            .disposed(by: disposeBag)
    }
    
    private func setNotification() {
        self.observer = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: OperationQueue.main)
        { [weak self] _ in
            if let observer = self?.observer {
                NotificationCenter.default.removeObserver(observer)
            }
            
            UIView.animate(withDuration: 0.3) {
                self?.layer.opacity = 0
            } completion: { _ in
                self?.removeFromSuperview()
            }
        }
    }
}

@resultBuilder
struct PopupTableVeiwBuilder {
    static func buildArray(_ components: [String]) -> [String] {
        return components
    }
    
    static func buildBlock(_ components: String...) -> [String] {
        return components
    }
}

class PopupTableViewCell: UITableViewCell {
    
    var titleLabel = CommonLabel(frame: .zero, fontMultiplier: 1.0)
    
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
    
    func makeUI() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(8)
            $0.trailing.bottom.equalToSuperview().offset(8)
        }
        
        layoutIfNeeded()
    }
}
