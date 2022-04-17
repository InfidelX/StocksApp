//
//  StocksViewModel.swift
//  StocksApp
//
//  Created by Jovancho Jovanovski on 17.4.22.
//

import Foundation

class StocksViewModel {
    
    var service: NetworkService!
    
    required init(service: NetworkService?) {
        self.service = service
    }
    
    func fetchStocks(completion: @escaping (Result<[Stock], Error>) -> Void) {
        service.getStocks() { result in
            completion(result)
        }
    }
    
}
