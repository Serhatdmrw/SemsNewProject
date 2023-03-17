//
//  HomeViewModel.swift
//  SemsNewsProject
//
//  Created by Serhat Demir on 15.03.2023.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func didFetchServiceSuccess(responseModel: Welcome)
    func didFetchServiceFail(message: String)
}

class HomeViewModel {
    
    // MARK: Delegate
    weak var delegate: HomeViewModelDelegate?
    
    func fechService() {
        ApiManager().fetchService { result in
            switch result {
            case .success(let response):
                self.delegate?.didFetchServiceSuccess(responseModel: response)
            case .failure(let error):
                self.delegate?.didFetchServiceFail(message: error.localizedDescription)
            }
        }
    }
}
