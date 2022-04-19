//
//  StockCell.swift
//  StocksApp
//
//  Created by Jovancho Jovanovski on 17.4.22.
//

import UIKit

@objc protocol StoreStockDelegate: AnyObject {
    @objc optional func storeStock(at index: Int)
    @objc optional func deleteStock(at index: Int)
}


class StockCell: UITableViewCell {
    
    static let height: CGFloat = 110

    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var marketCap: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    weak var delegate: StoreStockDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func configureCell(tableView: UITableView,
                              indexPath: IndexPath,
                              delegate: StoreStockDelegate?,
                              stock: Stock?,
                              isFromMyStocks: Bool = false) -> StockCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.identifier, for: indexPath) as? StockCell {
            
            guard let stock = stock else {
                return StockCell()
            }
            
            cell.delegate = delegate

            cell.companyName.text = stock.companyName
            
            if let cap = stock.marketCap {
                cell.marketCap.text = "Market cap: \(cap) $"
            }
            
            cell.addButton.tag = indexPath.row
            
            if isFromMyStocks {
                cell.addButton.setTitle("Delete", for: .normal)
                cell.addButton.addTarget(cell, action: #selector(deleteStock), for: .touchUpInside)
            } else {
                cell.addButton.setTitle("Add to my list", for: .normal)
                cell.addButton.addTarget(cell, action: #selector(storeStock), for: .touchUpInside)
            }
            
            return cell
        }
        
        return StockCell()
    }
    
    @objc func storeStock(_ sender: UIButton) {
        delegate?.storeStock?(at: sender.tag)
    }
    
    @objc func deleteStock(_ sender: UIButton) {
        delegate?.deleteStock?(at: sender.tag)
    }
    
}
