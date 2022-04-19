//
//  StockNewsViewModel.swift
//  StocksApp
//
//  Created by Jovancho Jovanovski on 19.4.22.
//

import Foundation

protocol StockNewsViewModel: AnyObject {
    var news: [Stock]? { get }
    
    func fetchStockNews(completion: @escaping (Bool) -> Void)
}

class StockNewsService: StockNewsViewModel {
    
    private let networkService: NetworkService!
    
    var news: [Stock]?
    
    required init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchStockNews(completion: @escaping (Bool) -> Void) {
        
    }
}
