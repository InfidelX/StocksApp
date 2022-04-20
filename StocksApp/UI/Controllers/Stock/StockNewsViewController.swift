//
//  StockNewsViewController.swift
//  StocksApp
//
//  Created by Jovancho Jovanovski on 19.4.22.
//

import UIKit

class StockNewsViewController: UIViewController {

    //MARK: - Properties
    private let viewModel: StockNewsViewModel = StockNewsService(networkService: NetworkManager())
    var stockSymbol: String?
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Properties
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchStockNews()
    }
    
    //MARK: - Methods
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: StockNewsCell.identifier, bundle: nil), forCellReuseIdentifier: StockNewsCell.identifier)
    }

    
    private func fetchStockNews() {
        if let stockSymbol = stockSymbol {
            viewModel.fetchStockNews(stockSymbol: stockSymbol, completion: { result in
                if result {
                    self.tableView.reloadData()
                } else {
                    // show no data message
                }
            })
        } else {
            // show no symbol provided error
        }
    }

}

//MARK: - UITableViewDelegate
extension StockNewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return StockNewsCell.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.news?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let news = viewModel.news, news.count > 0 {
            return StockNewsCell.configureCell(tableView: tableView, indexPath: indexPath, news: news[indexPath.row])
        } else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "No stocks found"
            return cell
        }
    }
    
}
