//
//  Endpoint.swift
//  GitTrends
//
//  Created by Osama Azmat Khan on 20/11/2021.
//

import Foundation

protocol Endpoint {
    /// HTTPS or HTTP
    var scheme: String { get }
    /// Example: "api.something.com"
    var baseURL: String { get }
    /// "/images/search/"
    var path: String { get }
    ///[URLQueryItem(name: "api_key", value: "ajshdy8yg37gbAGDj3")]
    var parameters: [URLQueryItem] { get }
    ///"GET"
    var method: String { get }
    ///"SomeFileName"
    var mockObjectFileName: String { get set }
}
