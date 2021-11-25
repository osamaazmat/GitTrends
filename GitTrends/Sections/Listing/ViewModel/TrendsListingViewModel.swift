//
//  TrendsListingViewModel.swift
//  GitTrends
//
//  Created by Osama Azmat Khan on 23/11/2021.
//

import Foundation

class TrendsListingTableViewModel {
    var id = 0
    var isExpanded = false
}

protocol TrendsListingViewModelDelegate: AnyObject {
    func successResponse(withData: GitHubRepoModel)
    func failureResponse()
}

class TrendsListingViewModel: NSObject {

    // MARK: - Properties
    var gitHubRepoData: GitHubRepoModel!
    var trendsListingList = [TrendsListingTableViewModel]()
    private var networkManager: NetworkProtocol!
    private weak var delegate: TrendsListingViewModelDelegate?
    
    // MARK: - Initializer
    init(networkManager: NetworkProtocol, delegate: TrendsListingViewModelDelegate) {
        super.init()
        self.networkManager = networkManager
        self.delegate = delegate
        getTrendsRepositories()
    }
}

// MARK: - Api Methods
extension TrendsListingViewModel {
    func getTrendsRepositories() {
        networkManager.request(endpoint: GitHubEndpoint(endpointType: .getTrendingGitRepos), completion: { (result: Result<GitHubRepoModel, Error>) in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                switch result {
                case .success(let response):
                    self.gitHubRepoData = response
                    self.delegate?.successResponse(withData: self.gitHubRepoData)
                case .failure(let error):
                    print(error.localizedDescription)
                    self.delegate?.failureResponse()
                }
            })
        })
    }
}

// MARK: - Data Methods
extension TrendsListingViewModel {
    
    func setupLocalDataStash() {
        trendsListingList = []
        for gitTrendsModel in gitHubRepoData.items {
            let trendModel          = TrendsListingTableViewModel()
            trendModel.id           = gitTrendsModel.id
            trendModel.isExpanded   = false
            self.trendsListingList.append(trendModel)
        }
    }
}
