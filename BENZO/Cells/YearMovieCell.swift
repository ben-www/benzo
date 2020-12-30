//
//  YearMovieCell.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/29/20.
//

import UIKit

class YearMovieCell: UITableViewCell {
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var benzoScoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func displayMovieTitle(title:String, rank:String) {
        self.movieTitleLabel.text = title
        self.benzoScoreLabel.text = rank
        return
    }
}
