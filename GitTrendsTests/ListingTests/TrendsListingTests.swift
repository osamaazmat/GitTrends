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
        trendsListingVC = TrendsListingViewController.init()
    }
    
    override func tearDown() {
        trendsListingVC.endAppearanceTransition()
        trendsListingVC = nil
    }
}

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
