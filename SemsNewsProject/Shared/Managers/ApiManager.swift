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
    private let apiKey = "&apiKey=0f8ebdf3fb89415399a34e7047179648"
    private let topHeadlinesEndPoint = "/top-headlines?Language=tr"
    private let searchEndPoint = "/everything?Language=tr&q="
    private let sortBy = "&sortBy=popularity"
    
    func fetchService(searchText: String?, completion: @escaping(Result<ResponseModel, Error>) -> Void) {
        
        var urlString = ""
        
        if let searchText = searchText {
            urlString = "\(baseUrl)\(searchEndPoint)\(searchText)\(sortBy)\(apiKey)"
        } else {
            urlString = "\(baseUrl)\(topHeadlinesEndPoint)\(apiKey)"
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let welcome = try JSONDecoder().decode(ResponseModel.self, from: data)
                completion(.success(welcome))
            } catch {
                completion(.failure(error))
                
            }
        }.resume()
    }
}
