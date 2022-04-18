//
//  StocksViewModel.swift
//  StocksApp
//
//  Created by Jovancho Jovanovski on 17.4.22.
//

import Foundation

protocol StocksViewModel {

    var stocks: [Stock]? { get }
    var filteredStocks: [Stock]? { get }
    var isSearchActive: Bool { get set }
    
    func fetchStocks(success: @escaping (Bool) -> Void)
    func sortAlphabetical()
    func sortMarketCap()
    func searchStocksBy(string: String )

}

class StocksService: StocksViewModel {
    
    private let networkService: NetworkService!
    
    var stocks: [Stock]?
    var filteredStocks: [Stock]?
    var isSearchActive: Bool = false
    
    required init(networkService: NetworkService?) {
        self.networkService = networkService
    }
    
    func fetchStocks(success: @escaping (Bool) -> Void) {
        networkService.getStocks() { result in
            switch result {
            case .failure(_):
                success(false)
            case .success(let stocks):
                self.stocks = stocks
                success(true)
            }
            
        }
    }

    func searchStocksBy(string: String ) {
        
        guard string != "", let stocks = stocks else {
            isSearchActive = false
            return
        }
        
        isSearchActive = true

        filteredStocks = stocks.filter({
            
            guard let name = $0.companyName else {
                return false
            }
            
            return name.starts(with: string)
            
        })
//        print("filteredStocks: \(String(describing: filteredStocks?.count))")

//        isSearchActive = filteredStocks?.count ?? 0 > 0
        
    }
    
    func sortAlphabetical()  {
        guard let sortedStocks = stocks else {
            return
        }
        
        stocks = sortedStocks.sorted(by:  {
            guard let company0 = $0.companyName, let company1 = $1.companyName else {
                return false
            }
            return company0 < company1
        })
    }
    
    func sortMarketCap() {
        guard let sortedStocks = stocks else {
            return
        }
        
        stocks = sortedStocks.sorted(by:  {
            guard let cap0 = $0.marketCap, let cap1 = $1.marketCap else {
                return false
            }
            return cap0 < cap1
        })
    }
    
}
