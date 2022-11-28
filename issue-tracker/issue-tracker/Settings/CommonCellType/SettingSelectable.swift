//
//  SettingSelectable.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/10/15.
//

import Foundation
import RxCocoa
import RxSwift

protocol SettingSelectable {
    var controlProperty: Observable<Any>? { get set }
    var controlEvent: Observable<Any>? { get set }
}
