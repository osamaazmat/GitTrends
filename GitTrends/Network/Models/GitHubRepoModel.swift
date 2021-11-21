//
//  GitHubRepoModel.swift
//  GitTrends
//
//  Created by Osama Azmat Khan on 20/11/2021.
//

import Foundation

// MARK: - GitHubRepoModel
struct GitHubRepoModel: Codable {
    var totalCount: Int
    var incompleteResults: Bool
    var items: [Item]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
    
    init(from decoder: Decoder) throws {
        let values          = try decoder.container(keyedBy: CodingKeys.self)
        totalCount          = try values.decodeIfPresent(Int.self, forKey: .totalCount) ?? 0
        incompleteResults   = try values.decodeIfPresent(Bool.self, forKey: .incompleteResults) ?? false
        items               = try values.decodeIfPresent([Item].self, forKey: .items) ?? []
    }
}

// MARK: - Item
struct Item: Codable {
    var id: Int
    var nodeID, name, fullName: String
    var itemPrivate: Bool
    var owner: Owner?
    var itemDescription: String
    var stargazersCount: Int
    var language: String

    enum CodingKeys: String, CodingKey {
        case id
        case nodeID = "node_id"
        case name
        case fullName = "full_name"
        case itemPrivate = "private"
        case owner
        case itemDescription = "description"
        case stargazersCount = "stargazers_count"
        case language
    }
    
    init(from decoder: Decoder) throws {
        let values          = try decoder.container(keyedBy: CodingKeys.self)
        id                  = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        nodeID              = try values.decodeIfPresent(String.self, forKey: .nodeID) ?? ""
        name                = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        fullName            = try values.decodeIfPresent(String.self, forKey: .fullName) ?? ""
        itemPrivate         = try values.decodeIfPresent(Bool.self, forKey: .itemPrivate) ?? false
        owner               = try values.decodeIfPresent(Owner.self, forKey: .owner)
        itemDescription     = try values.decodeIfPresent(String.self, forKey: .itemDescription) ?? ""
        stargazersCount     = try values.decodeIfPresent(Int.self, forKey: .stargazersCount) ?? 0
        language            = try values.decodeIfPresent(String.self, forKey: .language) ?? ""
    }
}

// MARK: - Owner
struct Owner: Codable {
    var login: String
    var id: Int
    var nodeID: String
    var avatarURL: String
    var gravatarID: String
    var url, htmlURL, followersURL: String
    var followingURL, gistsURL, starredURL: String
    var subscriptionsURL, organizationsURL, reposURL: String
    var eventsURL: String
    var receivedEventsURL: String
    var siteAdmin: Bool

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case siteAdmin = "site_admin"
    }
    
    init(from decoder: Decoder) throws {
        let values          = try decoder.container(keyedBy: CodingKeys.self)
        id                  = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        login               = try values.decodeIfPresent(String.self, forKey: .login) ?? ""
        nodeID              = try values.decodeIfPresent(String.self, forKey: .nodeID) ?? ""
        avatarURL           = try values.decodeIfPresent(String.self, forKey: .avatarURL) ?? ""
        gravatarID          = try values.decodeIfPresent(String.self, forKey: .gravatarID) ?? ""
        url                 = try values.decodeIfPresent(String.self, forKey: .url) ?? ""
        htmlURL             = try values.decodeIfPresent(String.self, forKey: .htmlURL) ?? ""
        followersURL        = try values.decodeIfPresent(String.self, forKey: .followersURL) ?? ""
        followingURL        = try values.decodeIfPresent(String.self, forKey: .followingURL) ?? ""
        gistsURL            = try values.decodeIfPresent(String.self, forKey: .gistsURL) ?? ""
        starredURL          = try values.decodeIfPresent(String.self, forKey: .starredURL) ?? ""
        subscriptionsURL    = try values.decodeIfPresent(String.self, forKey: .subscriptionsURL) ?? ""
        organizationsURL    = try values.decodeIfPresent(String.self, forKey: .organizationsURL) ?? ""
        reposURL            = try values.decodeIfPresent(String.self, forKey: .reposURL) ?? ""
        eventsURL           = try values.decodeIfPresent(String.self, forKey: .eventsURL) ?? ""
        receivedEventsURL   = try values.decodeIfPresent(String.self, forKey: .receivedEventsURL) ?? ""
        siteAdmin           = try values.decodeIfPresent(Bool.self, forKey: .siteAdmin) ?? false
    }
}
