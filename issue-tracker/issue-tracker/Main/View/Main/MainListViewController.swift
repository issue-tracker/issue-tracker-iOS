//
//  MainListViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/29.
//

import SnapKit
import FlexLayout
import UIKit
import RxSwift
import RxCocoa
import ReactorKit

enum MainListType {
    case issue(IndexPath?)
    case label(IndexPath?)
    case milestone(IndexPath?)
}

class MainListViewController: CommonProxyViewController {
    
    // Search field 에 관한 가이드라인
    // 출처 : (https://developer.apple.com/design/human-interface-guidelines/components/navigation-and-search/search-fields/)
    // Best practices
    // 1. 적절한 시간에 탐색을 시작하도록 하라. 바로 시작할 수도 있고, Return/Enter 등을 탭 해야될 수도 있다. 타이핑 중 계속 검색하려면 계속 결과가 수정되어야 한다.
    // 2. Search history 를 제공하는 것은 사용자의 선택으로 맡겨둬야 한다.
    
    private let padding: CGFloat = 8
    private var removePopupSubject = PublishSubject<PopupTableView?>()
    private var disposeBag = DisposeBag()
    private var popupView: PopupTableView?
    private let bookmarkScrollView = QueryBookmarkScrollView()
    
    private lazy var listSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [
            UIAction(title: "Issue", handler: { [weak self] _ in
                self?.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }),
            UIAction(title: "Label", handler: { [weak self] _ in
                self?.scrollView.setContentOffset(CGPoint(x: self?.scrollView.frame.width ?? 0, y: 0), animated: true)
            }),
            UIAction(title: "Milestone", handler: { [weak self] _ in
                self?.scrollView.setContentOffset(CGPoint(x: (self?.scrollView.frame.width ?? 0) * 2, y: 0), animated: true)
            }),
        ])
        control.accessibilityIdentifier = "listControl"
        
        return control
    }()
    
    private let reloadListSubject = PublishSubject<MainListType>()
    private let listItemSelected = PublishSubject<MainListType>()
    
    private lazy var issueList = IssueListViewController()
    private lazy var labelList = LabelListViewController()
    private lazy var milestoneList = MilestoneListViewController()
    
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
        button.accessibilityIdentifier = "profileView"
        
        return button
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(primaryAction: UIAction(handler: { action in
            self.navigationController?.present(UINavigationController(rootViewController: {
                let viewController = IssueEditViewController()
                viewController.reloadSubject = self.reloadListSubject
                viewController.reactor = IssueEditReactor()
                return viewController
            }()), animated: true)
        }))
        
        button.setBackgroundImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.accessibilityIdentifier = "issueUpdateEntry"
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defer {
            view.bringSubviewToFront(plusButton)
        }
        
        // MARK: addSubview
        view.addSubview(bookmarkScrollView)
        view.addSubview(listSegmentedControl)
        view.addSubview(scrollView)
        view.addSubview(plusButton)
        scrollView.addSubview(issueList.view)
        scrollView.addSubview(labelList.view)
        scrollView.addSubview(milestoneList.view)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: profileView)]
        
        // MARK: AutoLayout(SnapKit)
        bookmarkScrollView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(view.frame.height*0.035)
        }
        
        listSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(bookmarkScrollView.snp.bottom).offset(padding)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(padding)
            $0.height.equalTo(view.frame.height*0.055)
        }
        
        plusButton.snp.makeConstraints {
            $0.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.size.equalTo(CGSize(width: 54, height: 54))
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(listSegmentedControl.snp.bottom).offset(padding)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(padding)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        issueList.view.snp.makeConstraints {
            $0.size.equalToSuperview()
            $0.leading.equalTo(0)
        }
        
        labelList.view.snp.makeConstraints {
            $0.size.equalToSuperview()
            $0.leading.equalTo(issueList.view.snp.trailing)
        }
        
        milestoneList.view.snp.makeConstraints {
            $0.size.equalToSuperview()
            $0.leading.equalTo(labelList.view.snp.trailing)
        }
        
        // MARK: ScrollView for List
        scrollView.delegate = self
        scrollView.contentSize.width = scrollView.frame.width * 3
        
        // MARK: ScrollView for Bookmark(Query)
        bookmarkScrollView.showsHorizontalScrollIndicator = false
        bookmarkScrollView.insertButton(searchText: "is:open")
        bookmarkScrollView.insertButton(searchText: "milestone:default")
        
        // MARK: ETC
        listSegmentedControl.selectedSegmentIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        issueList.reactor = IssueListReactor()
        labelList.reactor = LabelListReactor()
        milestoneList.reactor = MilestoneListReactor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // MARK: RxCocoa
        listItemSelected
            .subscribe(onNext: { [weak self] type in
                switch type {
                case .issue(let indexPath):
                    guard let id = indexPath?.row else { return}
                    self?.tabBarController?.tabBar.isHidden = true
                    self?.navigationController?.pushViewController(IssueDetailViewController(id), animated: true)
                default:
                    return
                }
            })
            .disposed(by: disposeBag)
        
        removePopupSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { $0?.removeFromSuperview() })
            .disposed(by: disposeBag)
        
//        listSegmentedControl.rx.value
//            .bind(onNext: { [self] index in navigationItem.title = reactors[index].mainListStatus })
//            .disposed(by: disposeBag) // listSegmentedControl's action always excuted when view presented
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
                    LoginResponse.removeUserDefaults()
                    self.switchScreen(type: .login)
                }
            ])
        }
    }
}

extension MainListViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        guard popupView == nil, (searchBar.text ?? "").isEmpty else { return true }
        
        var popupFrame = searchBar.frame.offsetBy(dx: 0, dy: searchBar.frame.height + 8)
        popupFrame.size = CGSize(width: popupFrame.width / 2, height: 170)
        let popup = PopupTableView(frame: popupFrame, identifierAccessibility: "mainSearchBarPopup") {
            "is:"
            "milestone:"
            "label:"
            "title:"
        }
        popup.initialSetting()
        popupView = popup
        
        view.addSubview(popup)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty == false {
            removePopupSubject.onNext(popupView)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        removePopupSubject.onNext(popupView)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        defer {
            searchBar.text = nil
        }
        
        bookmarkScrollView.insertButton(searchText: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
}
