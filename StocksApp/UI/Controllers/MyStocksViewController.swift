//
//  MyStocksViewController.swift
//  StocksApp
//
//  Created by Jovancho Jovanovski on 17.4.22.
//

import UIKit

class MyStocksViewController: UIViewController {

    //MARK: - Properties
    private let viewModel: MyStocksViewModel = MyStocksService(databaseService: DBManager())
    
    //MARK: - IBOutlets
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.emptyStateLabel.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchLocalStocks(completion: { result in
            self.emptyStateLabel.isHidden = result
            self.tableView.isHidden = !result
            self.tableView.reloadData()
        })
    }
    
    //MARK: - Methods
    private func configureTableView() {
        tableView.register(UINib(nibName: StockCell.identifier, bundle: nil), forCellReuseIdentifier: StockCell.identifier)
    }

}

//MARK: - UITableViewDelegate
extension MyStocksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return StockCell.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.localStocks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let stocks = viewModel.localStocks, stocks.count > 0 {
            return StockCell.configureCell(tableView: tableView, indexPath: indexPath, delegate: self, stock: stocks[indexPath.row])
        }
        
        return UITableViewCell()
    }
    
}

extension MyStocksViewController: StoreStockDelegate {
    func deleteStock(at index: Int) {
        
    }
}
