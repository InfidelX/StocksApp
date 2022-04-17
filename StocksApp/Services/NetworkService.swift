//
//  NetworkService.swift
//  StocksApp
//
//  Created by Jovancho Jovanovski on 17.4.22.
//

import Foundation

struct API {
    private static let baseUrl = "https://financialmodelingprep.com/api/v3"
    private static let apiKey = "d64d179adb2bcbf73edd76abd7e9e477"
    
    static let stocksList = "\(API.baseUrl)/stock-screener?marketCapMoreThan=1000000000&volumeMoreThan=10000&sector=Technology&exchange=NASDAQ&limit=100&apikey=\(API.apiKey)"
    static func stocksNews(stock: Int) -> String{
      return String(format: "\(API.baseUrl)/stock_news?tickers=\(stock)&limit=1000&apikey=\(API.apiKey)")
    }
    
}

protocol NetworkService {
    func getStocks(completion: @escaping (Result<[Stock], Error>) -> Void)
}

class NetworkManager: NetworkService {
    
    static let api = API()
    
    let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)

    func getStocks(completion: @escaping (Result<[Stock], Error>) -> Void) {
        let queue = DispatchQueue.main

        guard let url = URL(string: API.stocksList) else {
            queue.async { completion(.failure(StocksError.invalidURL)) }
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                queue.async { completion(.failure(error)) }
                return
            }

            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                200 ..< 300 ~= httpResponse.statusCode
            else {
                queue.async { completion(.failure(StocksError.invalidResponse(response))) }
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                let news = try decoder.decode([Stock].self, from: data)
                queue.async { completion(.success(news)) }
            } catch let parseError {
                queue.async { completion(.failure(parseError)) }
            }
        }.resume()
    }
    
}
