//
//  ViewBindable.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/07/21.
//

import Foundation

/// ViewBinding에 의해 바인딩(종속) 되는 객체(예: ViewController는 View 를 바인딩 한다. 이 때, ViewController는 ViewBinding / View는 ViewBindable 이 된다).
protocol ViewBindable {
    var binding: ViewBinding? { get set }
}
