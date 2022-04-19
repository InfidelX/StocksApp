//
//  StockNews.swift
//  StocksApp
//
//  Created by Jovancho Jovanovski on 19.4.22.
//

import Foundation

struct StockNews: Codable {
    var symbol: String?
    var title: String?
    var image: String?
    var site: String?
    var text: String?
    var url: String?
    var publishedDate: String?
    
}
