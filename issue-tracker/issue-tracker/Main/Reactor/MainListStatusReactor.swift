//
//  MainListStatusReactor.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/08.
//

import Foundation
import ReactorKit

protocol MainListStatusReactor: Reactor {
    var mainListStatus: String { get }
}
