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
}

class MyStocksService: MyStocksViewModel {
    
    private let databaseService: DatabaseService!
    
    public var localStocks: [Stock]?
    
    required init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    func fetchLocalStocks(completion: @escaping (Bool) -> Void) {
        localStocks = databaseService.getStocks()
        completion(localStocks?.count ?? 0 > 0 ? true : false)
    }
    
}
