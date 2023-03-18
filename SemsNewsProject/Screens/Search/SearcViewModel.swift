//
//  HomeViewModel.swift
//  SemsNewsProject
//
//  Created by Serhat Demir on 18.03.2023.
//

import Foundation

protocol SearcViewModelDelegate: AnyObject {
    func didFetchServiceSuccess(responseModel: ResponseModel)
    func didFetchServiceFail(message: String)
}

class SearcViewModel {
    
    // MARK: - Delegate
    weak var delegate : SearcViewModelDelegate?
    
    func fechService(searchText: String?) {
        ApiManager().fetchService(searchText: searchText) { result in
            switch result {
            case .success(let response):
                self.delegate?.didFetchServiceSuccess(responseModel: response)
            case .failure(let error):
                self.delegate?.didFetchServiceFail(message: error.localizedDescription)
            }
        }
    }
}
