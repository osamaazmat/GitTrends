//
//  NetworkManager.swift
//  GitTrends
//
//  Created by Osama Azmat Khan on 20/11/2021.
//

import Foundation

protocol NetworkProtocol {
    func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> ())
}

final class NetworkManager: NetworkProtocol {
    
    func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> ()) {
        var components          = URLComponents()
        components.scheme       = endpoint.scheme
        components.path         = endpoint.path
        components.host         = endpoint.baseURL
        components.queryItems   = endpoint.parameters
        
        guard let url = components.url else { return }
    
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method
        
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
        
            guard error == nil else {
                completion(.failure(error!))
                print(error?.localizedDescription ?? "Unknown Error")
                return
            }
            
            guard response != nil, let data = data else { return }
            
            DispatchQueue.main.async {
                do {
                    let responseObject = try JSONDecoder().decode(T.self, from: data)
                    print(responseObject)
                    completion(.success(responseObject))
                    
                } catch let error {
                    print(error.localizedDescription)
                    let error = NSError(domain: "", code: 200, userInfo: [NSLocalizedDescriptionKey: "Failed to decode response"])
                    completion(.failure(error))
                }
              
            }
        }
        
        dataTask.resume()
    }
}
