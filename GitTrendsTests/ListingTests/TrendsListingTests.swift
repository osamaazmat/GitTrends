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
}
