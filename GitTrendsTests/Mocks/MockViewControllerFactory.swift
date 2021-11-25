//
//  MockViewControllerFactory.swift
//  GitTrendsTests
//
//  Created by Osama Azmat Khan on 25/11/2021.
//

import Foundation
@testable import GitTrends

class MockViewControllerFactory: ControllerFactoryProtocol {
    
    func makeTrendsListingViewController() -> TrendsListingViewController {
        let networkManager = MockNetworkManager()
        let trendsListingVC = TrendsListingViewController.init()
        let trendsListingViewModel = TrendsListingViewModel(networkManager: networkManager, delegate: trendsListingVC)
        trendsListingVC.trendsListingViewModel = trendsListingViewModel
        return trendsListingVC
    }
}

class MockViewControllerFaliureFactory: ControllerFactoryProtocol {
    
    func makeTrendsListingViewController() -> TrendsListingViewController {
        let networkManager = MockNetworkManagerFailure()
        let trendsListingVC = TrendsListingViewController.init()
        let trendsListingViewModel = TrendsListingViewModel(networkManager: networkManager, delegate: trendsListingVC)
        trendsListingVC.trendsListingViewModel = trendsListingViewModel
        return trendsListingVC
    }
}
