//
//  ViewBinding.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/21.
//

import Foundation

/// View를 바인딩 하려는 객체(예: ViewController는 View 를 바인딩 한다. 이 때, ViewController는 ViewBinding / View는 ViewBindable 이 된다).
protocol ViewBinding {
    var bindableHandler: ((Any?, ViewBindable) -> Void)? { get set }
}
