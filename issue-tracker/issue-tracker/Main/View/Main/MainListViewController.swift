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
    case issue(Int)
    case label(Int)
    case milestone(Int)
}

protocol ListViewRepresentingStatus {
    var statusDescription: String? { get }
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
    
    private(set) lazy var listSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Issue","Label","Milestone"])
        control.rx.selectedSegmentIndex.bind(onNext: { index in
            guard 0...2 ~= index else { return }
            let offset = CGPoint(x: self.listScrollView.frame.width * CGFloat(index), y: 0)
            self.listScrollView.setContentOffset(offset, animated: true)
            self.title = self.descriptables[index].statusDescription
        })
        .disposed(by: disposeBag)
        
        control.accessibilityIdentifier = "listControl"
        control.selectedSegmentIndex = 0
        
        return control
    }()
    
    private(set) var reloadListSubject = PublishSubject<MainListType>()
    private(set) var listItemSelected = PublishSubject<MainListType>()
    
    private lazy var issueListView: IssueListViewController = {
        let vc = IssueListViewController()
        self.addChild(vc) // trigger willMove(toParent:UIViewController?)
        return vc
    }()
    private lazy var labelListView: LabelListViewController = {
        let vc = LabelListViewController()
        self.addChild(vc)
        return vc
    }()
    private lazy var milestoneListView: MilestoneListViewController = {
        let vc = MilestoneListViewController()
        self.addChild(vc)
        return vc
    }()
    private var descriptables: [ListViewRepresentingStatus] {
        [issueListView, labelListView, milestoneListView]
    }
    
    private(set) var listScrollView: UIScrollView = {
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
        let button = UIButton()
        button.rx.tap.subscribe(onNext: { _ in
            let viewController = IssueEditViewController()
            viewController.reloadSubject = self.reloadListSubject
            self.navigationController?.present(UINavigationController(rootViewController: viewController), animated: true)
        })
        .disposed(by: disposeBag)
        
        button.setBackgroundImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.accessibilityIdentifier = "issueUpdateEntry"
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: addSubview
        view.addSubview(bookmarkScrollView)
        view.addSubview(listSegmentedControl)
        view.addSubview(listScrollView)
        view.addSubview(plusButton)
        listScrollView.addSubview(issueListView.view)
        listScrollView.addSubview(labelListView.view)
        listScrollView.addSubview(milestoneListView.view)
        view.bringSubviewToFront(plusButton)
        
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
        
        listScrollView.snp.makeConstraints {
            $0.top.equalTo(listSegmentedControl.snp.bottom).offset(padding)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(padding)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        issueListView.view.snp.makeConstraints {
            $0.size.equalTo(listScrollView.snp.size)
            $0.leading.equalTo(0)
        }
        
        labelListView.view.snp.makeConstraints {
            $0.size.equalTo(listScrollView.snp.size)
            $0.leading.equalTo(issueListView.view.snp.trailing)
        }
        
        milestoneListView.view.snp.makeConstraints {
            $0.size.equalTo(listScrollView.snp.size)
            $0.leading.equalTo(labelListView.view.snp.trailing)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        bookmarkScrollView.showsHorizontalScrollIndicator = false
        
        listScrollView.delegate = self
        listScrollView.contentSize.width = listScrollView.frame.width * 3
        
        issueListView.listItemSelected = self.listItemSelected
        issueListView.didMove(toParent: self)
        labelListView.didMove(toParent: self)
        milestoneListView.didMove(toParent: self)
        
        // MARK: RxCocoa
        listItemSelected
            .subscribe(onNext: { [weak self] type in
                switch type {
                case .issue(let id):
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
