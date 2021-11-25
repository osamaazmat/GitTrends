//
//  TrendsListingTests.swift
//  GitTrends
//
//  Created by Osama Azmat Khan on 21/11/2021.
//

import Foundation
import XCTest
@testable import GitTrends

//APIGeneric.shared.selectedFile = CSCnicExpiryFileNames.cnicIssuanceSuccess.rawValue

enum TrendsListingTestsFileNames : String {
    case trendingGitRepoSuccessResponse = "TrendingGitRepoSuccessResponse"
}

class TrendsListingTests: XCTestCase {

    var trendsListingVC: TrendsListingViewController!
    
    override func setUp() {
        super.setUp()
        let mockVCFactory = MockViewControllerFactory()
        trendsListingVC = mockVCFactory.makeTrendsListingViewController()
        trendsListingVC.loadViewIfNeeded()
        trendsListingVC.beginAppearanceTransition(true, animated: false)
    }
    
    override func tearDown() {
        trendsListingVC.endAppearanceTransition()
        trendsListingVC = nil
    }
}

// MARK: API Tests
extension TrendsListingTests {
    
    func testGitTrendsApi() {
        var endpoint = GitHubEndpoint(endpointType: .getTrendingGitRepos)
        endpoint.mockObjectFileName = TrendsListingTestsFileNames.trendingGitRepoSuccessResponse.rawValue
        
        let networkManager = MockNetworkManager()
        let exp = expectation(description: "Loading Git Trends")
        
        networkManager.request(endpoint: endpoint, completion: { (result: Result<GitHubRepoModel, Error>) in
            
            switch result {
            case .success(let response):
                XCTAssertTrue(response.items.count > 5)
            case .failure(_):
                XCTFail()
            }
            
            exp.fulfill()
        })
        
        waitForExpectations(timeout: 3)
    }
}

// MARK: View Controller Tests
extension TrendsListingTests {
    
    func testListingVCOutlets() {
        XCTAssertNotNil(trendsListingVC.menuBtn, "Menu Button should be connected")
        XCTAssertNotNil(trendsListingVC.tableView, "Table View should be connected")
        XCTAssertNotNil(trendsListingVC.retryButton, "Retry Button should be connected")
        XCTAssertNotNil(trendsListingVC.retryView, "Retry View should be connected")
        XCTAssertNotNil(trendsListingVC.animationContainerView, "Animation Container View should be connected")
    }
    
    func testListingVCSetupUI() {
        trendsListingVC.setupUI()
        XCTAssert(trendsListingVC.menuBtn.title(for: .normal) == "")
        XCTAssert(trendsListingVC.tableView.delegate != nil)
        XCTAssert(trendsListingVC.tableView.dataSource != nil)
    }
    
    func testListingVCShowRetryView() {
        trendsListingVC.showRetryView()
        XCTAssert(trendsListingVC.retryView.isHidden == false)
    }
    
    func testListingVCHideRetryView() {
        trendsListingVC.hideRetryView()
        XCTAssert(trendsListingVC.retryView.isHidden == true)
    }
    
    func testListingVCPullToRefreshSuccess() {
        trendsListingVC.refresh(UIRefreshControl())
        
        let exp = expectation(description: "Test after 2 seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: 2.0)
        if result == XCTWaiter.Result.timedOut {
            XCTAssert(trendsListingVC.trendsListingViewModel.gitHubRepoData.items.count > 0)
        } else {
            XCTFail("Test Failed")
        }
    }
    
    func testListingVCOnPressRetryBtn() {
        trendsListingVC.onPressRetryBtn(UIButton())
        
        let exp = expectation(description: "Test after 2 seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: 2.0)
        if result == XCTWaiter.Result.timedOut {
            XCTAssert(trendsListingVC.trendsListingViewModel.gitHubRepoData.items.count > 0)
        } else {
            XCTFail("Test Failed")
        }
    }
    
}
    
// MARK: - TableView Tests
extension TrendsListingTests {
    
    func testTableViewNumberOfRows() {
        trendsListingVC.shouldAnimate = true
        var countNumberOfRows = trendsListingVC.tableView(trendsListingVC.tableView, numberOfRowsInSection: 0)
        XCTAssert(countNumberOfRows == 10)
        
        
        trendsListingVC.trendsListingViewModel.getTrendsRepositories()
        
        let exp = expectation(description: "Test after 2 seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: 2.0)
        if result == XCTWaiter.Result.timedOut {
            trendsListingVC.shouldAnimate = false
            countNumberOfRows = trendsListingVC.tableView(trendsListingVC.tableView, numberOfRowsInSection: 0)
            XCTAssert(countNumberOfRows == trendsListingVC.trendsListingViewModel.gitHubRepoData.items.count)
        } else {
            XCTFail("Test Failed")
        }
    }
    
    func testTableViewCellForRowAt() {
        
        let cell = trendsListingVC.tableView(trendsListingVC.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(cell)
    }
    
    func testTableViewDidSelectRow() {
        trendsListingVC.tableView(trendsListingVC.tableView, didSelectRowAt: IndexPath(item: 0, section: 0))
        if let currentCell = trendsListingVC.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? TrendsListingTableViewCell {
            XCTAssert(currentCell.extraInfoView.isHidden == false)
        }
        
        trendsListingVC.tableView(trendsListingVC.tableView, didSelectRowAt: IndexPath(item: 0, section: 0))
        if let currentCell = trendsListingVC.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? TrendsListingTableViewCell {
            XCTAssert(currentCell.mainDescLabel.text == trendsListingVC.trendsListingViewModel.gitHubRepoData.items[0].fullName)
        }
    }
}
    
// MARK: - Failure API Tests
extension TrendsListingTests {
    func testListingVCPullToRefreshFail() {
        
        let mockVCFactory = MockViewControllerFaliureFactory()
        trendsListingVC = mockVCFactory.makeTrendsListingViewController()
        trendsListingVC.loadViewIfNeeded()
        trendsListingVC.beginAppearanceTransition(true, animated: false)
        
        let exp = expectation(description: "Test after 2 seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: 2.0)
        if result == XCTWaiter.Result.timedOut {
            XCTAssert(trendsListingVC.trendsListingViewModel.gitHubRepoData == nil)
            XCTAssert(trendsListingVC.retryView.isHidden == false)
        } else {
            XCTFail("Test Failed")
        }
    }
    
    func testListingVCOnPressRetryBtnFail() {
        
        let mockVCFactory = MockViewControllerFaliureFactory()
        trendsListingVC = mockVCFactory.makeTrendsListingViewController()
        trendsListingVC.loadViewIfNeeded()
        trendsListingVC.beginAppearanceTransition(true, animated: false)
        
        trendsListingVC.retryButton.sendActions(for: .touchDown)
        
        let exp = expectation(description: "Test after 2 seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: 2.0)
        if result == XCTWaiter.Result.timedOut {
            XCTAssert(trendsListingVC.trendsListingViewModel.gitHubRepoData == nil)
            XCTAssert(trendsListingVC.retryView.isHidden == false)
        } else {
            XCTFail("Test Failed")
        }
    }
}
