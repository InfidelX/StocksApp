//
//  StocksViewModel.swift
//  StocksApp
//
//  Created by Jovancho Jovanovski on 17.4.22.
//

import UIKit

protocol StocksViewModel: AnyObject {
    var stocks: [Stock]? { get }
    
    func fetchStocks(completion: @escaping (Bool) -> Void)
    func sortAlphabetical()
    func sortMarketCap()
    func searchStocksBy(string: String )
    
    func storeStock(at index: Int, completion: @escaping (StoreResult) -> Void)
}

class StocksService: StocksViewModel {

    private let networkService: NetworkService!
    private let databaseService: DatabaseService!
    
    private var initialStocks: [Stock]?
    public var stocks: [Stock]?

    required init(networkService: NetworkService, databaseService: DatabaseService) {
        self.networkService = networkService
        self.databaseService = databaseService
    }
    
    //MARK: Networking
    func fetchStocks(completion: @escaping (Bool) -> Void) {
        networkService.getStocks() { result in
            switch result {
            case .failure(_):
                completion(false)
            case .success(let stocks):
                self.initialStocks = stocks
                self.stocks = stocks
                completion(true)
            }
        }
    }

    //MARK: Search
    func searchStocksBy(string: String ) {
        
        guard string != "", let stocks = initialStocks else { return }
        
        self.stocks = stocks.filter({
            
            guard let name = $0.companyName else { return false }
            
            return name.starts(with: string)
            
        })
    }
    
    //MARK: Sorting
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
    
    //MARK: Storing
    func storeStock(at index: Int, completion: @escaping (StoreResult) -> Void) {
        let localStocks = databaseService.getStocks()
        if let stocks = stocks {
            let symbol = stocks[index].symbol
            if let localStocks = localStocks, localStocks.contains(where: { $0.symbol == symbol }) {
                completion(.contains)
            } else {
                databaseService.save(stock: stocks[index])
                completion(.success)
            }
        } else {
            completion(.failure)
        }

    }
}

extension StocksViewModel {
    
    //MARK: Presentation
    func showAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        return alert
    }
    
}
