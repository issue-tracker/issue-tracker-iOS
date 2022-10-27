//
//  issue_trackerUnitTest_Issue.swift
//  issue-trackerUnitTests
//
//  Created by 백상휘 on 2022/08/30.
//

import XCTest
import RxSwift

class issue_trackerUnitTest_Issue: XCTestCase {
    var expectation: XCTestExpectation!
    
    var issueModel: MainViewSingleRequestModel<AllIssueEntity, MilestoneListEntity>?
    var labelModel: MainViewRequestModel<LabelListEntity>?
    var milestoneModel: MainViewSingleRequestModel<AllMilestoneEntity, MilestoneListEntity>?
    
    var issueDetailModel: IssueDetailViewModel?
    let model = IssueAddRemoveModel(URL.issueApiURL!)
    var disposeBag = DisposeBag()
    override func setUp() {
        URLProtocol.registerClass(MainViewProtocol.self)
        expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1
    }
    override func tearDown() {
        URLProtocol.unregisterClass(MainViewProtocol.self)
    }

    func testIssueList() throws {
        
        issueModel = MainViewSingleRequestModel<AllIssueEntity, MilestoneListEntity>(URL(string: Bundle.main.path(forResource: "Issues", ofType: "json") ?? ""))
        issueModel?.builder.setURLQuery(["page" : "0"])
        
        issueModel?.dataSource
            .subscribe(onNext: { list in
                if list.isEmpty == false {
                    self.expectation.fulfill()
                }
            })
            .disposed(by: disposeBag)
        issueModel?.requestEntity()
        
        
        wait(for: [expectation], timeout: (1.5))
    }
    
    func testLabelList() throws {
        expectation.expectedFulfillmentCount = 3
        labelModel = MainViewRequestModel<LabelListEntity>(URL(string: Bundle.main.path(forResource: "Labels", ofType: "json") ?? ""))
        
        labelModel?.requestIssueList(0) { _, list in
            self.expectation.fulfill()
        }
        labelModel?.requestIssueList(1) { _, list in
            self.expectation.fulfill()
        }
        labelModel?.reloadIssueList { list in
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: (3 * 1.5))
    }
    
    func testMilestoneList() throws {
        milestoneModel = MainViewSingleRequestModel<AllMilestoneEntity, MilestoneListEntity>(URL(string: Bundle.main.path(forResource: "Milestones", ofType: "json") ?? ""))
        
        milestoneModel?.dataSource.subscribe(onNext: { list in
            if list.isEmpty == false {
                self.expectation.fulfill()
            }
        })
        .disposed(by: disposeBag)
        
        milestoneModel?.requestEntity()
        
        wait(for: [expectation], timeout: 1.5)
    }
    
    func testAddAndRemoveIssueDetail() throws {
        URLProtocol.unregisterClass(MainViewProtocol.self)
        expectation.expectedFulfillmentCount = 2
        model.addIssue(
            IssueAddParameter(
                title: "testIssues",
                comment: "comment in testIssue",
                assigneeIds: [],
                labelIds: [],
                milestoneId: nil
            )
        ).subscribe(onNext: { entity in
            if let entity = entity {
                self.expectation.fulfill()
                
                self.model
                    .removeIssue(entity.id)
                    .subscribe(onNext: { message in
              if let message = message {
                            XCTFail(message)
                        } else {
                            self.expectation.fulfill()
                        }
                    })
                    .disposed(by: DisposeBag())
            }
        })
        .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5.0)
    }
}
