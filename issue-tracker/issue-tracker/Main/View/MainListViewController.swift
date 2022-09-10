//
//  MainListViewController.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/29.
//

import SnapKit
import UIKit

class MainListViewController: CommonProxyViewController, ViewBinding {
    
    private let padding: CGFloat = 8
    
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
        
        return control
    }()
    
    lazy var bindableHandler: ((Any?, ViewBindable) -> Void)? = { [weak self] entity, bindable in
        DispatchQueue.main.async {
            if let entity = entity as? IssueListEntity, bindable is IssueListViewController {
                
                self?.navigationController?.pushViewController(IssueListDetailViewController(entity), animated: true)
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
        
        view.addSubview(listSegmentedControl)
        view.addSubview(scrollView)
        view.addSubview(plusButton)
        
        issueListViewController.binding = self
        
        listSegmentedControl.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(padding)
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
