//
//  StocksViewController.swift
//  StocksApp
//
//  Created by Jovancho Jovanovski on 17.4.22.
//

import UIKit

class StocksViewController: UIViewController {
    
    //MARK: - Properties
    private var viewModel: StocksViewModel = StocksService(networkService: NetworkManager())

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
        
        viewModel.fetchStocks(success: {  [weak self] result in
            if result {
                self?.tableView.reloadData()
            } else {
                //TODO: show no data message
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
        
        if viewModel.isSearchActive, let filtered = viewModel.filteredStocks, filtered.count > 0 {
            return filtered.count
        }
        
        guard let stocks = viewModel.stocks, stocks.count > 0 else {
            return 0
        }
        return stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.identifier, for: indexPath) as? StockCell {
            
            if viewModel.isSearchActive, let filtered = viewModel.filteredStocks, filtered.count > 0 {
                if let stock = viewModel.filteredStocks?[indexPath.row] {
                    cell.companyName.text = stock.companyName
                }
                return cell
            }
            
            if let stock = viewModel.stocks?[indexPath.row] {
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
        viewModel.searchStocksBy(string: searchBar.searchTextField.text ?? "")
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchStocksBy(string: searchText)
        tableView.reloadData()
    }
    
}

