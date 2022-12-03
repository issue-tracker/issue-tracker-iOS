//
//  issue_trackerUnitTest_Settings.swift
//  issue-trackerUnitTests
//
//  Created by 백상휘 on 2022/11/30.
//

import XCTest
import ReactorKit
import RxCocoa
import RxSwift

final class issue_trackerUnitTest_Settings: XCTestCase {
    private var disposeBag = DisposeBag()
    
    func test_getList() throws {
        let mainListModel = SettingMainListModel()
        
        let generalInfo = mainListModel.getMainItems[0]
        let allListInfo = mainListModel.getMainItems[1]
        
        let generalInfoSubList = mainListModel.getList(generalInfo.id)
        let allListInfoSubList = mainListModel.getList(allListInfo.id)
        
        XCTAssertEqual(generalInfoSubList.count, 2)
        
        XCTAssertEqual(allListInfoSubList.count, 3)
        
        for list in generalInfoSubList {
            XCTAssertEqual(generalInfoSubList, mainListModel.getList(list.parentId))
        }
        
        for list in allListInfoSubList {
            XCTAssertEqual(allListInfoSubList, mainListModel.getList(list.parentId))
        }
    }
    
    func test_settingList() throws {
        let reactor = SettingReactor()
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 2
        
        func sendAction(_ action: SettingReactor.Action) -> Observable<ActionSubject<SettingReactor.Action>> {
            Observable<SettingReactor.Action>
                .create({ observer in
                    observer.onNext(action)
                    observer.onCompleted()
                    return Disposables.create()
                })
                .map({ _ in reactor.action})
        }
        
        let first = sendAction(SettingReactor.Action.listSelected(reactor.settingList.first!.id))
            .do(onCompleted: {
                print("first!!!!")
                if reactor.settingList.count == 2 {
                    expectation.fulfill()
                }
            })
                
        let second = sendAction(SettingReactor.Action.listSelected(reactor.settingList.first!.id))
            .do(onCompleted: {
                print("second!!!!")
                if reactor.settingList.count == 0 {
                    expectation.fulfill()
                }
            })
                
        Observable
            .concat([first, second])
            .subscribe()
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 3.0)
    }
}
