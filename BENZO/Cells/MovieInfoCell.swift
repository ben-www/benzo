//
//  MovieInfoCell.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/3/20.
//

import UIKit

class MovieInfoCell: UITableViewCell {

    @IBOutlet weak var keyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayInfo(title:String) {
        self.keyLabel.text = title
        return
    }


}
