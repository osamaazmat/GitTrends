//
//  MockNetworkManager.swift
//  GitTrends
//
//  Created by Osama Azmat Khan on 21/11/2021.
//

import Foundation

final class MockNetworkManager: NetworkProtocol {
    
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
        
        if let path = Bundle(for: type(of: self)).path(forResource: responseJson, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                DispatchQueue.main.async {
                    if let responseObject = try? JSONDecoder().decode(T.self, from: data) {
                        completion(.success(responseObject))
                    }
                    else {
                        let error = NSError(domain: "", code: 200, userInfo: [NSLocalizedDescriptionKey: "Failed to decode response"])
                        completion(.failure(error))
                    }
                }
                
            } catch let jsonError {
                print(jsonError.localizedDescription)
            }
        }
    }
}
