//
//  MainListViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/29.
//

import SnapKit
import UIKit
import RxSwift
import RxCocoa

class MainListViewController: CommonProxyViewController, ViewBinding {
    
    // Search field 에 관한 가이드라인
    // 출처 : (https://developer.apple.com/design/human-interface-guidelines/components/navigation-and-search/search-fields/)
    // Best practices
    // 1. placeholder 등을 이용해서 hints 를 보여줄 수 있게 해야 된다. (O)
    // 2. safari browser 가 searchfield 를 클릭하면 북마크를 보여주는 것처럼, 북마크같은 기능을 제공하라. (O)
    // 3. 적절한 시간에 탐색을 시작하도록 하라. 바로 시작할 수도 있고, Return/Enter 등을 탭 해야될 수도 있다. 타이핑 중 계속 검색하려면 계속 결과가 수정되어야 한다.
    // 4. Clear button 을 제공하라. (O)
    // 5. Search history 를 제공하는 것은 사용자의 선택으로 맡겨둬야 한다.
    // Scope bars
    // 스코프 바를 이용하면 미리 정해진 결과를 얻을 수 있게 해준다. 사용자 선호도를 향상시킬 수 있다. ( UISegmentedControl 로 대체 완료 )
    // Platform considerations
    // 네비게이션 바에도 검색 창을 만들 수 있다. 이렇게 될 경우 미리 정해진 appearance 를 갖게 된다(예: 아래로 스와이프를 하면 숨겨짐).
    // UIViewController 내부에 searchController 프로퍼티를 사용하여 시스템에서 제공하는 appearance 를 사용할 수 있다(네비게이션 바에 위치).
    // 커스텀화된 appearance 가 필요하다면 UISearchBar 를 이용한 검색바나 UISearchTextField 를 이용하여 searchField 의 커스텀 배경을 넣는다.
    
    private let padding: CGFloat = 8
    /// ViewController 에 의해  firstResponder 가 정해질 경우 임시적으로 PopupTableView 의 표시를 막는다.
    private var shouldPopupTableView = true
    
    private(set) lazy var searchBar: UISearchBar = {
        let result = UISearchBar()
        result.delegate = self
        result.placeholder = "검색 시 적용된 조건이 아래 추가됩니다."
        return result
    }()
    private let bookmarkScrollView = QueryBookmarkScrollView()
    
    private lazy var listSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [
            UIAction(title: "Issue", handler: { [weak self] _ in
                self?.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                self?.navigationItem.title = self?.issueListViewController.modelStatusCount ?? "0/0"
            }),
            UIAction(title: "Label", handler: { [weak self] _ in
                self?.scrollView.setContentOffset(CGPoint(x: self?.scrollView.frame.width ?? 0, y: 0), animated: true)
                self?.navigationItem.title = self?.labelListViewController.modelStatusCount ?? "0"
            }),
            UIAction(title: "Milestone", handler: { [weak self] _ in
                self?.scrollView.setContentOffset(CGPoint(x: (self?.scrollView.frame.width ?? 0) * 2, y: 0), animated: true)
                self?.navigationItem.title = self?.milestoneListViewController.modelStatusCount ?? "0/0"
            }),
        ])
        control.accessibilityIdentifier = "listControl"
        
        return control
    }()
    
    lazy var bindableHandler: ((Any?, ViewBindable) -> Void)? = { [weak self] entity, bindable in
        DispatchQueue.main.async {
            if let cellTitle = entity as? String, bindable is PopupTableView {
                self?.searchBar.text = cellTitle
                self?.shouldPopupTableView = false
                self?.searchBar.becomeFirstResponder()
                self?.shouldPopupTableView = true
            }
            
            if let entity = entity as? IssueListEntity, bindable is IssueListViewController {
                self?.tabBarController?.tabBar.isHidden = true
                self?.navigationController?.pushViewController(IssueDetailViewController(entity.id, status: .open), animated: true)
            }
            
            if let button = self?.listSegmentedControl, button.selectedSegmentIndex == 0 {
                self?.navigationItem.title = self?.issueListViewController.modelStatusCount ?? "0/0"
            }
        }
    }
    
    private lazy var issueListViewController = IssueListViewController()
    private lazy var labelListViewController = LabelListViewController()
    private lazy var milestoneListViewController = MilestoneListViewController()
    
    lazy var pageList: [UIViewController] = [
        issueListViewController, labelListViewController, milestoneListViewController
    ]
    
    private var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isPagingEnabled = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.accessibilityIdentifier = "listScrollView"
        return view
    }()
    
    private lazy var profileView: ProfileImageButton = {
        let profileButtonWidth = navigationController?.navigationBar.frame.height ?? 44
        let button = ProfileImageButton(frame: CGRect(x: 0, y: 0, width: profileButtonWidth, height: profileButtonWidth))
        if let urlString = UserDefaults.standard.string(forKey: "profileImage") {
            button.profileImageURL = urlString
        }
        
        button.addInteraction(UIContextMenuInteraction(delegate: self))
        
        return button
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(primaryAction: UIAction(handler: { action in
            self.navigationController?.pushViewController(IssueEditViewController(), animated: true)
        }))
        button.setBackgroundImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defer {
            view.bringSubviewToFront(plusButton)
        }
        
        view.addSubview(searchBar)
        view.addSubview(bookmarkScrollView)
        view.addSubview(listSegmentedControl)
        view.addSubview(scrollView)
        view.addSubview(plusButton)
        
        issueListViewController.binding = self
        
        searchBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(padding)
            $0.height.equalTo(view.frame.height*0.055)
        }
        
        bookmarkScrollView.binding = self
        bookmarkScrollView.showsHorizontalScrollIndicator = false
        bookmarkScrollView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(padding)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(padding)
            $0.height.equalTo(view.frame.height*0.035)
        }
        
        listSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(bookmarkScrollView.snp.bottom).offset(padding)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(padding)
            $0.height.equalTo(view.frame.height*0.055)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(listSegmentedControl.snp.bottom).offset(padding)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(padding)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        plusButton.snp.makeConstraints {
            $0.bottom.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
            $0.size.equalTo(CGSize(width: 44, height: 44))
        }
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: profileView)]
        view.layoutIfNeeded()
        
        scrollView.delegate = self
        scrollView.contentSize.width = 0
        for (index, page) in pageList.enumerated() {
            scrollView.addSubview(page.view)
            page.view.frame = scrollView.bounds
            page.view.frame.origin.x = CGFloat(index) * scrollView.frame.width
            scrollView.contentSize.width += scrollView.frame.width
        }
        
        listSegmentedControl.selectedSegmentIndex = 0
    }
}

extension MainListViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / scrollView.frame.width)
        listSegmentedControl.selectedSegmentIndex = page
    }
}

extension MainListViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { elements in
            UIMenu(title: "", options: .displayInline, children: [
                UIAction(title: "logout") { _ in
                    UserDefaults.standard.removeObject(forKey: "memberId")
                    self.switchScreen(type: .login)
                },
            ])
        }
    }
}

extension MainListViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        guard shouldPopupTableView else { return true }
        
        var popupFrame = searchBar.frame.offsetBy(dx: 0, dy: searchBar.frame.height + 8)
        popupFrame.size = CGSize(width: popupFrame.width, height: 170)
        let popup = PopupTableView(frame: popupFrame, identifierAccessibility: "mainSearchBarPopup") {
            "is:"
            "milestone:"
            "label:"
            "title:"
        }
        popup.initialSetting()
        popup.binding = self
        
        view.addSubview(popup)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async { [weak self] in
            self?.view.subviews.filter({ $0 is PopupTableView }).forEach { popup in
                popup.removeFromSuperview()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        defer {
            searchBar.text = nil
        }
        
        bookmarkScrollView.insertButton(searchText: searchBar.text ?? "")
        print(bookmarkScrollView.queryPath)
    }
}
