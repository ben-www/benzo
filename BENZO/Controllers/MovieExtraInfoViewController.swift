//
//  MovieExtraInfoViewController.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/5/20.
//

import UIKit

class MovieExtraInfoViewController: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!

    
    
    var movie:Movie?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = self.movie?.Title
        
    }
    

}
