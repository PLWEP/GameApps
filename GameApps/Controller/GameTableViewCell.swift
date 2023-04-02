//
//  GameTableViewCell.swift
//  GameApps
//
//  Created by PLWEP on 30/03/23.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cellRatingLabel: UILabel!
    @IBOutlet weak var cellDateLabel: UILabel!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellFavoriteButton: UIButton!
    var isFavorite: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func addToFavorite(_ sender: Any) {
        isFavorite = !isFavorite
        loadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension GameTableViewCell {
    func loadData() {
        if isFavorite {
            cellFavoriteButton.setImage(UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .small)), for: .normal)
        } else {
            cellFavoriteButton.setImage(UIImage(systemName: "star", withConfiguration: UIImage.SymbolConfiguration(scale: .small)), for: .normal)
        }
    }
}
