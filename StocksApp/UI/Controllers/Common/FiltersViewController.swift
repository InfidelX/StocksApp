//
//  FiltersViewController.swift
//  StocksApp
//
//  Created by Jovancho Jovanovski on 20.4.22.
//

import UIKit

protocol CountryCodesDelegate: AnyObject {
    func didSelect(codes: [String])
    func didClearFilter()
}

class FiltersViewController: UIViewController {

    private let viewModel: FiltersViewModel = FiltersService(selectedItems: [Int]())

    //MARK: - Properties
    var countryCodes: [String]?
    weak var delegate: CountryCodesDelegate?
    
    //MARK: - IBOutlets
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    //MARK: - Methods
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsMultipleSelection = true
        tableView.allowsMultipleSelectionDuringEditing = true
        
        tableView.register(UINib(nibName: FilterCell.identifier, bundle: nil), forCellReuseIdentifier: FilterCell.identifier)
    }
    
    @IBAction func applyFilters(_ sender: Any) {
        let codes = viewModel.selectedItems.map({ (index) -> String in
            guard let countryCodes = countryCodes else {
                return ""
            }

            return countryCodes[index]
        })

        if !codes.isEmpty {
            delegate?.didSelect(codes: codes)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearFilters(_ sender: Any) {
        delegate?.didClearFilter()
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - UITableViewDelegate
extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryCodes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: FilterCell.identifier) as? FilterCell {
            if let codes = countryCodes {
                cell.codeLabel.text = codes[indexPath.row]
            }
            return cell
        }

        return UITableViewCell()

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectItem(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        viewModel.deselectItem(at: indexPath.row)
    }
}
