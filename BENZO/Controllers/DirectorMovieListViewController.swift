//
//  DirectorMovieListViewController.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/5/20.
//

import UIKit

class DirectorMovieListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var benzoScoreLabel: UILabel!
    
    var directorName:String?
    var data = [Movie]()
    var directorMovies = [Movie]()
    
    var jBenzoData:JBenzoData?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = directorName
        
        tableView.delegate = self
        tableView.dataSource = self

        // Get the Average Benzo score for Dir,  MOVIE LIST pass in from last VC
        var avg = getAvgBENZO()
        benzoScoreLabel.text = String(avg)
        
        self.directorMovies.sort(by: { $0.BENZO! > $1.BENZO! })
        
        
        JBenzoService.retrieveJBenzoData(data: self.data) { (retrievedData) in
            self.jBenzoData = retrievedData
            
            if self.jBenzoData != nil && ((self.jBenzoData?.hasJBenzo) != nil) && (((self.jBenzoData?.showJBenzo)!)) {
                self.directorMovies.sort(by: { $0.jBENZO! > $1.jBENZO! })
                avg = self.getAvgBENZO()
                self.benzoScoreLabel.text = String(avg)
                self.benzoScoreLabel.textColor = .systemPurple

            }
            self.tableView.reloadData()

        }


    }
    
    
    
    
    func getAvgBENZO() -> Double {
        
        var avg = 0.0
        
        for mov in self.directorMovies {
            avg += mov.BENZO!
        }
        
        if self.jBenzoData != nil && ((self.jBenzoData?.hasJBenzo) != nil) && (((self.jBenzoData?.showJBenzo)!)) {
            avg = 0.0
            for mov in self.directorMovies {
                avg += mov.jBENZO!
            }
        }
        
        return avg / Double(self.directorMovies.count)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "dirMovieInfo" {

            let dirMovieInfoController = segue.destination as! DirectorMovieInfoViewController
            
            dirMovieInfoController.data = self.data

            if tableView.indexPathForSelectedRow != nil {
                // add BENZO overall rating (pass value)

                dirMovieInfoController.movie = directorMovies[tableView.indexPathForSelectedRow!.row]
                tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
            }

        }
        
        
    }
    
    
    
    @IBAction func homeTapped(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    

}


// MARK: UITableViewDelegate, UITableViewDataSource
extension DirectorMovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.directorMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.directorMovieCellId , for: indexPath) as? DirectorMovieCell
        
        
        let movie = self.directorMovies[indexPath.row]
        
        cell?.displayMovieTitle(title:movie.Title!, rank: String(movie.BENZO!))
        
        if self.jBenzoData != nil && ((self.jBenzoData?.hasJBenzo) != nil) && (((self.jBenzoData?.showJBenzo)!)) {
            let avg = round(10000.0 * movie.jBENZO!) / 10000.0
            cell?.displayMovieTitle(title:movie.Title!, rank: String(avg), jBenzo: true)

        }
        
        return cell!
        
    }
    
    
    
}
