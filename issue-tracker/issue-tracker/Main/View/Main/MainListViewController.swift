//
//  MainListViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/29.
//

import SnapKit
import FlexLayout
import RxCocoa
import ReactorKit

typealias ListType = MainListViewController.MainListType

protocol ListViewRepresentingStatus {
    var statusDescription: String { get }
}

class MainListViewController: CommonProxyViewController {
    
    enum MainListType {
        case issue(Int), label(Int), milestone(Int)
    }
    
    private var reloadListSubject = PublishSubject<MainListType>(),
                listItemSelected = PublishSubject<MainListType>(),
                removePopupSubject = PublishSubject<PopupTableView?>()
    private var disposeBag = DisposeBag()
    
    private var popupView: PopupTableView?
    private let bookmarkScrollView = QueryBookmarkScrollView()
    private func getViewController<T: ListViewRepresentingStatus>(type: T.Type) -> T where T: UIViewController {
        let vc = type.init()
        addChild(vc) // trigger willMove(toParent:UIViewController?)
        return vc
    }
    
    private lazy var issueListVC = getViewController(type: IssueListViewController.self)
    private lazy var labelListVC = getViewController(type: LabelListViewController.self)
    private lazy var milestoneListVC = getViewController(type: MilestoneListViewController.self)
    private var descriptables: [ListViewRepresentingStatus] {
        [getViewController(type: IssueListViewController.self), labelListVC, milestoneListVC]
    }
    
    private(set) lazy var listSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Issue","Label","Milestone"])
        control.accessibilityIdentifier = "listControl"
        control.selectedSegmentIndex = 0
        control.rx.selectedSegmentIndex
            .filter({0...2 ~= $0})
            .bind(onNext: { [weak self] inx in
                guard let self = self else { return }
                
                let scrollView = self.listScrollView
                let offset = CGPoint(x: scrollView.frame.width * CGFloat(inx), y: 0)
                scrollView.setContentOffset(offset, animated: true)
                self.title = self.descriptables[inx].statusDescription
            })
            .disposed(by: disposeBag)
        
        return control
    }()
    
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
        button.setBackgroundImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.accessibilityIdentifier = "issueUpdateEntry"
        button.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let vc = IssueEditViewController()
                vc.reloadSubject = self?.reloadListSubject
                self?.navigationController?
                    .present(UINavigationController(rootViewController: vc), animated: true)
            })
            .disposed(by: disposeBag)
        
        return button
    }()
    
    override func loadView() {
        super.loadView()
        listScrollView.delegate = self
        bookmarkScrollView.showsHorizontalScrollIndicator = false
        [bookmarkScrollView, listSegmentedControl, listScrollView, plusButton].forEach { v in
            view.addSubview(v)
        }
        
        [issueListVC, labelListVC, milestoneListVC].forEach { vc in
            listScrollView.addSubview(vc.view)
        }
        
        let padding: CGFloat = 8
        
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callSetting()
        
        issueListVC.listItemSelected = self.listItemSelected
        issueListVC.didMove(toParent: self)
        
        view.bringSubviewToFront(plusButton)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: profileView)]
        
        listItemSelected
            .compactMap({ type -> Int? in
                switch type {
                case .issue(let id): return id
                default: return nil
                }
            })
            .subscribe(onNext: { [weak self] id in
                self?.tabBarController?.tabBar.isHidden = true
                self?.navigationController?.pushViewController(IssueDetailViewController(id), animated: true)
            })
            .disposed(by: disposeBag)
        
        removePopupSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { $0?.removeFromSuperview() })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listScrollView.contentSize.width = listScrollView.frame.width * 3
        
        issueListVC.view.snp.makeConstraints {
            $0.size.equalTo(listScrollView.snp.size)
            $0.top.equalTo(listScrollView.snp.top)
            $0.leading.equalTo(0)
        }
        
        labelListVC.view.snp.makeConstraints {
            $0.size.equalTo(listScrollView.snp.size)
            $0.leading.equalTo(issueListVC.view.snp.trailing)
            $0.top.equalTo(listScrollView.snp.top)
        }
        
        milestoneListVC.view.snp.makeConstraints {
            $0.size.equalTo(listScrollView.snp.size)
            $0.leading.equalTo(labelListVC.view.snp.trailing)
            $0.top.equalTo(listScrollView.snp.top)
        }
    }
    
    override func callSetting() {
        let model = MainListCallSettingModel<SettingItemColor>()
        
        for title in [
            I18N.M_ST_SVC_TCELL_CONTENTS_LIST_ISSUE_BGCOLOR,
            I18N.M_ST_SVC_TCELL_CONTENTS_LIST_LABEL_BGCOLOR,
            I18N.M_ST_SVC_TCELL_CONTENTS_LIST_MILESTONE_BGCOLOR,
        ] {
            model.settingTitle = title
            
            guard 
                let settingItem = model.settingValue,
                let _ = UIColor(settingItem: settingItem)
            else {
                continue
            }
        }
    }
}

extension MainListViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        // caculate index that heading.
        listSegmentedControl.selectedSegmentIndex = Int(targetContentOffset.pointee.x / scrollView.frame.width)
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

// Search field 에 관한 가이드라인
// 출처 : (https://developer.apple.com/design/human-interface-guidelines/components/navigation-and-search/search-fields/)
// Best practices
// 1. 적절한 시간에 탐색을 시작하도록 하라. 바로 시작할 수도 있고, Return/Enter 등을 탭 해야될 수도 있다. 타이핑 중 계속 검색하려면 계속 결과가 수정되어야 한다.
// 2. Search history 를 제공하는 것은 사용자의 선택으로 맡겨둬야 한다.
extension MainListViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        guard (searchBar.text ?? "").isEmpty else { return true }
        
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
        defer { searchBar.text = nil }
        
        bookmarkScrollView.insertButton(searchText: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
}
