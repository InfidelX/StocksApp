//
//  StockNewsCell.swift
//  StocksApp
//
//  Created by Jovancho Jovanovski on 20.4.22.
//

import UIKit

class StockNewsCell: UITableViewCell {
    
    static let height: CGFloat = 200

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var siteLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func configureCell(tableView: UITableView,
                              indexPath: IndexPath,
                              news: StockNews?) -> StockNewsCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: StockNewsCell.identifier, for: indexPath) as? StockNewsCell {
            
            guard let news = news else {
                return StockNewsCell()
            }
            
            if let publishDate = news.publishedDate {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

                if let date = formatter.date(from: publishDate) {
                    formatter.dateFormat = "EEEE, MMM d, yyyy"
                    cell.dateLabel.text = formatter.string(from: date)
                }
            }

            cell.siteLabel.text = news.site
            cell.titleLabel.text = news.title
            
            if let imageUrl = news.image {
                cell.imgView.loadFrom(url: imageUrl)
            }
                        
            return cell
        }
        
        return StockNewsCell()
    }
    
}
