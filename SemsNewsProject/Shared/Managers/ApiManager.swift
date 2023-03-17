//
//  ApiManager.swift
//  SemsNewsProject
//
//  Created by Serhat Demir on 15.03.2023.
//

import Foundation

class ApiManager {
    
    // MARK: - Constants
    private let baseUrl = "https://newsapi.org/v2"
    private let apiKey = "0f8ebdf3fb89415399a34e7047179648"
    
    func fetchService(completion: @escaping(Result<Welcome, Error>) -> Void) {
        
        guard let url = URL(string: "\(baseUrl)/top-headlines?Language=tr&apiKey=\(apiKey)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let welcome = try JSONDecoder().decode(Welcome.self, from: data)
                completion(.success(welcome))
            } catch {
                completion(.failure(error))
                
            }
        }.resume()
    }
}
