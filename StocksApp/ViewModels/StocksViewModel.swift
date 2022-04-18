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
    func sortAlphabetical(_ stocks: [Stock]) -> [Stock]
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
                self.stocks = self.sortAlphabetical(stocks)
                success(true)
            }
            
        }
    }

    func searchStocksBy(string: String ) {
        
        guard string != "", let stocks = stocks else {
            isSearchActive = false
            return
        }

        filteredStocks = stocks.filter({
            
            guard let name = $0.companyName else {
                return false
            }
            
            return name.starts(with: string)
            
        })
        
        isSearchActive = filteredStocks?.count ?? 0 > 0
    }
    
    func sortAlphabetical(_ stocks: [Stock]) -> [Stock] {
        let result = stocks.sorted(by:  {
            
            guard let company0 = $0.companyName, let company1 = $1.companyName else {
                return false
            }

            return company0 < company1
            
        })
        return result
    }
    
}
