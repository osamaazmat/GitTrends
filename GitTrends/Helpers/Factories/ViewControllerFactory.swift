//
//  ViewControllerFactory.swift
//  GitTrends
//
//  Created by Osama Azmat Khan on 25/11/2021.
//

import Foundation

protocol ControllerFactoryProtocol {
    func makeTrendsListingViewController() -> TrendsListingViewController
}

class ViewControllerFactory: ControllerFactoryProtocol {
    func makeTrendsListingViewController() -> TrendsListingViewController {
        let networkManager = NetworkManager()
        let trendsListingVC = TrendsListingViewController()
        let trendsListingViewModel = TrendsListingViewModel(networkManager: networkManager, delegate: trendsListingVC)
        trendsListingVC.trendsListingViewModel = trendsListingViewModel
        return trendsListingVC
    }
}
