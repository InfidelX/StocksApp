//
//  StocksError.swift
//  StocksApp
//
//  Created by Jovancho Jovanovski on 18.4.22.
//

import Foundation

enum StocksError: Error {
    case invalidURL
    case invalidResponse(URLResponse?)
}
