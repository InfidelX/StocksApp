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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
