//
//  StockNewsViewModel.swift
//  StocksApp
//
//  Created by Jovancho Jovanovski on 19.4.22.
//

import Foundation

protocol StockNewsViewModel: AnyObject {
    var news: [StockNews]? { get }
    
    func fetchStockNews(stockSymbol: String, completion: @escaping (Bool) -> Void)
}

class StockNewsService: StockNewsViewModel {
    
    private let networkService: NetworkService!
    
    var news: [StockNews]?
    
    required init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchStockNews(stockSymbol: String, completion: @escaping (Bool) -> Void) {
        networkService.getStocksNews(stockSymbol: stockSymbol, completion:  { result in
            switch result {
            case .failure(_):
                completion(false)
            case .success(let news):
                self.news = news
                completion(true)
            }
        })
    }
}
