//
//  StocksViewModel.swift
//  StocksApp
//
//  Created by Jovancho Jovanovski on 17.4.22.
//

import Foundation

protocol StocksViewModel {
    var stocks: [Stock]? { get }
    
    func fetchStocks(success: @escaping (Bool) -> Void)
    func sortAlphabetical()
    func sortMarketCap()
    func searchStocksBy(string: String )
}

class StocksService: StocksViewModel {
    
    private let networkService: NetworkService!
    
    private var initialStocks: [Stock]?
    public var stocks: [Stock]?

    required init(networkService: NetworkService?) {
        self.networkService = networkService
    }
    
    func fetchStocks(success: @escaping (Bool) -> Void) {
        networkService.getStocks() { result in
            switch result {
            case .failure(_):
                success(false)
            case .success(let stocks):
                self.initialStocks = stocks
                self.stocks = stocks
                success(true)
            }
        }
    }

    func searchStocksBy(string: String ) {
        
        guard string != "", let stocks = initialStocks else { return }
        
        self.stocks = stocks.filter({
            
            guard let name = $0.companyName else { return false }
            
            return name.starts(with: string)
            
        })
    }
    
    func sortAlphabetical()  {
        guard let sortedStocks = stocks else { return }
        
        stocks = sortedStocks.sorted(by: {
            guard let company0 = $0.companyName, let company1 = $1.companyName else {
                return false
            }
            return company0 < company1
        })
    }
    
    func sortMarketCap() {
        guard let sortedStocks = stocks else { return }
        
        stocks = sortedStocks.sorted(by: {
            guard let cap0 = $0.marketCap, let cap1 = $1.marketCap else {
                return false
            }
            return cap0 < cap1
        })
    }
    
}
