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
    @IBAction func sortAlphabetical(_ sender: Any) {
        viewModel.sortAlphabetical()
        tableView.reloadData()
    }
    
    @IBAction func sortByMarketCap(_ sender: Any) {
        viewModel.sortMarketCap()
        tableView.reloadData()
    }
    
    @IBAction func showAdditionalFilters(_ sender: Any) {
    }
    
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
        
//        if viewModel.isSearchActive {
//            if let filtered = viewModel.filteredStocks, filtered.count > 0 {
//                return filtered.count
//            } else {
//                return 1
//            }
//        }
        
        return viewModel.stocks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

//        if viewModel.isSearchActive {
//            if let filtered = viewModel.filteredStocks, filtered.count > 0 {
//                return StockCell.configureCell(tableView: tableView, indexPath: indexPath, delegate: self, stock: viewModel.filteredStocks?[indexPath.row])
//            } else {
//                let cell = UITableViewCell()
//                cell.textLabel?.text = "No stocks found"
//                return cell
//            }
//
//        } else {
        if let stocks = viewModel.stocks, stocks.count > 0 {
            return StockCell.configureCell(tableView: tableView, indexPath: indexPath, delegate: self, stock: stocks[indexPath.row])
        } else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "No stocks found"
            return cell
        }
//        }
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchStocksBy(string: searchText)
        tableView.reloadData()
    }
    
}

//MARK: - StoreStockDelegate
extension StocksViewController: StoreStockDelegate {
    
    func storeStock(at index: Int) {
        // add storing logic to view model
        print("storeStock at: \(index)")
    }
    
}

