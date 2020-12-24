//
//  MovieCell.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/3/20.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var benzoScoreLabel: UILabel!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayMovieTitle(title:String, rank:String, jBenzo: Bool = false) {
        self.movieTitleLabel.text = title
        self.benzoScoreLabel.text = rank
        benzoScoreLabel.textColor = .systemGreen

        if jBenzo {
            benzoScoreLabel.textColor = .systemPurple
        }
        else {
            
        }
        
        return
    }

}
