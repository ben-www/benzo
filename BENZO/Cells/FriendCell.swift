//
//  FriendCell.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 1/3/21.
//

import UIKit

class FriendCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayUsername(username:String) {
        self.usernameLabel.text = username
        return
    }

}
