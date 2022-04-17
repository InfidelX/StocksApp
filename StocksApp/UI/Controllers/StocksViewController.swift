//
//  StocksViewController.swift
//  StocksApp
//
//  Created by Jovancho Jovanovski on 17.4.22.
//

import UIKit

class StocksViewController: UIViewController {
    
    //MARK: - Properties
    private let viewModel = StocksViewModel(service: NetworkManager())
    private var stocks: [Stock]?

    //MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchStocks()
    }

    
    //MARK: - IBActions
    
    
    //MARK: - Methods
    private func configureTableView() {
        tableView.register(UINib(nibName: StockCell.identifier, bundle: nil), forCellReuseIdentifier: StockCell.identifier)
    }
    
    private func fetchStocks() {
        viewModel.fetchStocks(completion: { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let stocks):
                self?.stocks = stocks
                self?.tableView.reloadData()
            }
        })
    }
}

//MARK: - UITableViewDelegate
extension StocksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return StockCell.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let stocks = stocks, stocks.count > 0 else {
            return 0
        }
        return stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.identifier, for: indexPath) as? StockCell {
            if let stock = stocks?[indexPath.row] {
                cell.companyName.text = stock.companyName
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
}

//MARK: - UISearchBarDelegate
extension StocksViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
}

