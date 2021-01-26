//
//  WatchPartyCell.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 1/26/21.
//

import UIKit

class WatchPartyCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoresLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
