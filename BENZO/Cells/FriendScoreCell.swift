//
//  FriendScoreCell.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 1/6/21.
//

import UIKit

class FriendScoreCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    func displayUsername(title:String, score:String) {
        self.titleLabel.text = title
        self.scoreLabel.text = score
        return
    }
}
