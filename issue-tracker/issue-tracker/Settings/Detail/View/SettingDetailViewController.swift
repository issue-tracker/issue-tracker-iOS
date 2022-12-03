//
//  SettingDetailViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/12/02.
//

import UIKit
import SnapKit
import ReactorKit
import RxSwift

class SettingDetailViewController: UIViewController, View {
    typealias Reactor = SettingDetailReactor
    
    /// DetailView의 상태 중 SettingItemValue에 해당하는 값을 List의 Reactor's State로 적용하고 싶을 경우 참조한다.
    var parentReactor: SettingReactor?
    
    private let collectionView: UICollectionView = {
        let view = UICollectionView()
        return view
    }()
    
    var disposeBag: DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reactor = Reactor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func bind(reactor: SettingDetailReactor) {
        
    }
}
