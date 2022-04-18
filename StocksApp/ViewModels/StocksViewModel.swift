//
//  StocksViewModel.swift
//  StocksApp
//
//  Created by Jovancho Jovanovski on 17.4.22.
//

import Foundation

protocol StocksViewModel {
    func fetchStocks(completion: @escaping (Result<[Stock], Error>) -> Void)
}

class StocksService: StocksViewModel {
    
    private let networkService: NetworkService!
    
    required init(networkService: NetworkService?) {
        self.networkService = networkService
    }
    
    func fetchStocks(completion: @escaping (Result<[Stock], Error>) -> Void) {
        networkService.getStocks() { result in
            completion(result)
        }
    }
    
}
