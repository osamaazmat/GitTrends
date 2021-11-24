//
//  TrendsListingViewModel.swift
//  GitTrends
//
//  Created by Osama Azmat Khan on 23/11/2021.
//

import Foundation

protocol TrendsListingViewModelDelegate: AnyObject {
    func successResponse(withData: GitHubRepoModel)
    func failureResponse()
}

class TrendsListingViewModel: NSObject {
    
    private var networkManager: NetworkProtocol!
    var gitHubRepoData: GitHubRepoModel!
    private weak var delegate: TrendsListingViewModelDelegate?
    
    init(networkManager: NetworkProtocol, delegate: TrendsListingViewModelDelegate) {
        super.init()
        self.networkManager = networkManager
        self.delegate = delegate
        getTrendsRepositories()
    }
    
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
