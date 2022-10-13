//
//  SettingIssueListViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/06.
//

import SnapKit
import UIKit

/// 쿼리를 직접 입력할지, 미리 입력된 쿼리를 저장하고 사용하는 뷰를 보여줄지 정함.
///
/// Best Practices(https://developer.apple.com/design/human-interface-guidelines/components/layout-and-organization/collections)
///
/// 가능하다면 기본 열과 그리드 레이아웃을 사용하자. 기본적인 수평 열이나 그리드는 간단하고 사용자가 기대한 효과 그대로이다. 커스텀 레이아웃은 사용자에게 혼란을 주거나 오류가 발생할 수 있다.
///
/// 텍스트에는 단순한 테이블을 고려해보자. 기본적으로 더 간단하고 효과적으로 텍스트 기반의 정보를 받아들일 수 있다.
///
/// 아이템을 선택하기 쉽게 만들어야 한다. 컬렉션의 아이템에 접근하는 것이 매우 어렵다면, 사용자들은 컨텐츠에 대한 흥미를 잃을 것이다. 이미지에는 적당한 패딩을 넣어 정확히 집중하도록 하고 겹치는 부분을 제거한다.
///
/// 커스텀 상호작용을 넣어보자. 기본적으로 탭을 통해 선택하고, 누르고 있으면 수정이 되고, 스와이프를 하면 스크롤이 된다. 언제든 원한다면 커스텀 액션을 넣어보자.
///
/// 사용자가 삽입, 삭제, 재정렬을 할 때는 애니메이션을 사용해서 피드백을 해보자. 컬렉션은 이같은 액션에 기본 애니메이션을 제공하지만 커스텀 애니메이션도 제공할 수 있다.
///
/// 추가: CollectionView 를 이용한 2 X 2  레이아웃. Radio 버튼 필요.
class SettingIssueListViewController: UIViewController {
    private let padding: CGFloat = 8
    
    private var collectionView: UICollectionView!
    private lazy var dataSource = CommonSettingCollectionViewDataSource(collectionView: collectionView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Issue"
        
        let layout = UICollectionViewFlowLayout()
        let cellWidth = (view.frame.width / 2) - (padding * 2)
        
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * 1.618) // 황금비율 참고
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SettingCollectionViewCell.self, forCellWithReuseIdentifier: SettingCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = dataSource
        collectionView.reloadData()
    }
}
