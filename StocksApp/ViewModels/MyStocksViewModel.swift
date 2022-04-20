//
//  MyStocksViewModel.swift
//  StocksApp
//
//  Created by Jovancho Jovanovski on 19.4.22.
//

import Foundation

protocol MyStocksViewModel: AnyObject {
    var localStocks: [Stock]? { get }
    
    func fetchLocalStocks(completion: @escaping (Bool) -> Void)
    func deleteLocalStock(at index: Int, completion: @escaping (Bool) -> Void)
}

class MyStocksService: MyStocksViewModel {
    
    private let databaseService: DatabaseService!
    
    public var localStocks: [Stock]?
    
    required init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    //MARK: - Database access
    func fetchLocalStocks(completion: @escaping (Bool) -> Void) {
        localStocks = databaseService.getStocks()
        completion(localStocks?.count ?? 0 > 0 ? true : false)
    }
    
    func deleteLocalStock(at index: Int, completion: @escaping (Bool) -> Void) {
        if let localStocks = localStocks {
            databaseService.delete(stock: localStocks[index], completion: { [weak self] result in
                self?.localStocks = self?.databaseService.getStocks()
                completion(result)
            })
        } else {
            completion(false)
        }
    }
    
}
