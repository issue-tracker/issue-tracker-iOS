//
//  QueryBookmarkScrollView.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/09/26.
//

import UIKit
import RxSwift
import RxCocoa

class QueryBookmarkScrollView: UIScrollView, ViewBindable {
    
    private var queries = Set<Bookmark>()
    
    var binding: ViewBinding?
    
    private var contentSizeWidthRelay = BehaviorRelay<CGPoint>(value: .zero)
    private var disposeBag = DisposeBag()
    var lastView: UIView? {
      subviews.filter({$0 is BookmarkButton}).max(by: { $0.frame.maxX < $1.frame.maxX })
    }
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      initialSetting()
    }
    
    required init?(coder: NSCoder) {
      super.init(coder: coder)
      initialSetting()
    }
    
    private func initialSetting() {
      contentSizeWidthRelay
        .subscribe { [weak self] event in
          switch event {
          case .next(let point):
            guard let currentWidth = self?.contentSize.width, currentWidth < point.x else { return }
            self?.contentSize.width = point.x + 8
          default:
            self?.contentSize.width = self?.frame.width ?? 0
          }
        }
        .disposed(by: disposeBag)
    }
    
    @discardableResult
    func insertButton(_ key: String, _ value: String) -> BookmarkButton? {
        let text = "\(key):\(value)"
        let bookmark = Bookmark(query: text)
        
        guard queries.insert(bookmark).inserted else {
            return nil
        }
        
        let button = BookmarkButton(frame: CGRect(
            origin: CGPoint(x: (lastView?.frame.maxX ?? 0) + 8, y: 0),
            size: CGSize(width: frame.width / (text.count > 12 ? 2 : 3.5), height: frame.height)
        ))
        
        button.setBookmark(bookmark)
        button.addTarget(self, action: #selector(buttonTouchUpInside(_:)), for: .touchUpInside)
        addSubview(button)
        
        contentSizeWidthRelay.accept(CGPoint(x: button.frame.maxX, y: 0))
        
        return button
    }
    
    @objc func buttonTouchUpInside(_ sender: BookmarkButton) {
        if let bookmark = sender.bookmark {
            queries.remove(bookmark)
        }
        
        DispatchQueue.main.async { [weak self] in
            sender.removeFromSuperview()
            let viewsAfterRemove = self?.subviews.filter({$0 is BookmarkButton && $0.frame.maxX > sender.frame.maxX})
            viewsAfterRemove?.forEach({ view in
                view.frame.origin.x -= (sender.frame.width + 8)
            })
        }
    }
    
    func dispose() {
      self.disposeBag = DisposeBag()
    }
}

class BookmarkButton: UIButton {
    var bookmark: Bookmark?
    func setBookmark(_ bookmark: Bookmark) {
        self.bookmark = bookmark
        titleLabel?.adjustsFontSizeToFitWidth = true
        setTitle(bookmark.query, for: .normal)
        backgroundColor = UIColor.getRandomColor()
        setCornerRadius()
    }
}

class BookmarkLabel: CommonLabel {
    override func makeUI(_ fontMultiplier: CGFloat) {
        super.makeUI(fontMultiplier)
        setCornerRadius()
        backgroundColor = UIColor.getRandomColor()
    }
}

struct Bookmark: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(query)
    }
    
    let query: String
    var queryEncoded: String {
        var query = query
        let replaceColon = ":".addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) // %3A
        var safeCount = 100
        
        while let replaceColon = replaceColon, let index = query.firstIndex(of: Character(Unicode.Scalar(58))), safeCount > 0 {
            query.replaceSubrange(index...index, with: replaceColon)
            safeCount -= 1
        }
        
        return query
    }
}