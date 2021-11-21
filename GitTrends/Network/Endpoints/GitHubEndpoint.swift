//
//  GitHubEndpoint.swift
//  GitTrends
//
//  Created by Osama Azmat Khan on 20/11/2021.
//

import Foundation

//https://api.github.com/search/repositories?q=language=+sort:stars

enum GitHubEndpointType {
    case getTrendingGitRepos
}

struct GitHubEndpoint: Endpoint {
    
    var endpointType: GitHubEndpointType = .getTrendingGitRepos
    
    var scheme: String {
        switch endpointType {
        default:
            return "https"
        }
    }
    
    var baseURL: String {
        switch endpointType {
        default:
            return "api.github.com"
        }
    }
    
    var path: String {
        switch endpointType {
        case .getTrendingGitRepos:
            return "/search/repositories"
        }
    }
    
    var parameters: [URLQueryItem] {
        
        switch endpointType {
        case .getTrendingGitRepos:
            return [
                URLQueryItem(name: "q", value: "language=+sort:stars")
            ]
        }
    }
    
    var method: String {
        switch endpointType {
        default:
            return "GET"
        }
    }
    
    var mockObjectFileName: String = ""
}
