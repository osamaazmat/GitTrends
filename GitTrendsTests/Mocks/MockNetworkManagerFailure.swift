//
//  MockNetworkManagerFailure.swift
//  GitTrendsTests
//
//  Created by Osama Azmat Khan on 25/11/2021.
//

import Foundation

final class MockNetworkManagerFailure: NetworkProtocol {
    
    func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> ()) {
        var components          = URLComponents()
        components.scheme       = endpoint.scheme
        components.path         = endpoint.path
        components.host         = endpoint.baseURL
        components.queryItems   = endpoint.parameters
        
        guard let url = components.url else { return }
    
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method
        
        let responseJson = endpoint.mockObjectFileName
        
        let error = NSError(domain: "", code: 200, userInfo: [NSLocalizedDescriptionKey: "Failed to decode response"])
        completion(.failure(error))
    }
}
