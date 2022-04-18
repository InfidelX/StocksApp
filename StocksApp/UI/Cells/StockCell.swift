//
//  StockCell.swift
//  StocksApp
//
//  Created by Jovancho Jovanovski on 17.4.22.
//

import UIKit

class StockCell: UITableViewCell {
    
    static let height: CGFloat = 110

    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var marketCap: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func configureCell(tableView: UITableView, indexPath: IndexPath, stock: Stock) -> StockCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.identifier, for: indexPath) as? StockCell {
            cell.companyName.text = stock.companyName
            
            if let cap = stock.marketCap {
                cell.marketCap.text = "Market cap: \(cap) $"
            }
            return cell
        }
        
        return StockCell()
    }
    
}
