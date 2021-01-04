//
//  FriendCell.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 1/3/21.
//

import UIKit

class FriendCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayUsername(username:String, hasAccepted:Bool = false) {
        self.usernameLabel.text = username
        statusLabel.text = "Pending"
        
        if hasAccepted {
            statusLabel.alpha = 0
        }
        
        return
    }

}
