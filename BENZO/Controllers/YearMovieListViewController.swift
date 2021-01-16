//
//  YearMovieListViewController.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/29/20.
//

import UIKit

class YearMovieListViewController: UIViewController {
    
    var jBenzoData:JBenzoData?

    var year:String?
    var data = [Movie]()
    var yearMovies = [Movie]()
    var avg:Double?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var benzoScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = year
        
        tableView.delegate = self
        tableView.dataSource = self
        
        benzoScoreLabel.text = String(avg!)
        
        self.yearMovies.sort(by: { $0.BENZO! > $1.BENZO! })
        
        JBenzoService.retrieveJBenzoData(data: self.data) { (retrievedData) in
            self.jBenzoData = retrievedData
            
            if self.jBenzoData != nil && ((self.jBenzoData?.hasJBenzo) != nil) && (((self.jBenzoData?.showJBenzo)!)) {
                self.yearMovies.sort(by: { $0.jBENZO! > $1.jBENZO! })
                let avg = self.getAvgBENZO()
                self.benzoScoreLabel.text = String(avg)
                self.benzoScoreLabel.textColor = .systemPurple

            }
            self.tableView.reloadData()

        }


    }
    
    
    func getAvgBENZO() -> Double {
        
        var avg = 0.0
        
        for mov in self.yearMovies {
            avg += mov.BENZO!
        }
        
        if self.jBenzoData != nil && ((self.jBenzoData?.hasJBenzo) != nil) && (((self.jBenzoData?.showJBenzo)!)) {
            avg = 0.0
            for mov in self.yearMovies {
                avg += mov.jBENZO!
            }
        }
        
        return avg / Double(self.yearMovies.count)
    }

    
    
    @IBAction func homeTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        

        let dirMovieInfoController = segue.destination as! DirectorMovieInfoViewController

        if tableView.indexPathForSelectedRow != nil {
            // add BENZO overall rating (pass value)

            dirMovieInfoController.movie = yearMovies[tableView.indexPathForSelectedRow!.row]
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
        }

    
        
        
    }
    

}


// MARK: UITableViewDelegate, UITableViewDataSource
extension YearMovieListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.yearMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.yearMovieCellId , for: indexPath) as? YearMovieCell
        
        
        let movie = self.yearMovies[indexPath.row]
        
        cell?.displayMovieTitle(title:movie.Title!, rank: String(movie.BENZO!))
        
        if self.jBenzoData != nil && ((self.jBenzoData?.hasJBenzo) != nil) && (((self.jBenzoData?.showJBenzo)!)) {
            let avg = round(10000.0 * movie.jBENZO!) / 10000.0
            cell?.displayMovieTitle(title:movie.Title!, rank: String(avg), jBenzo: true)

        }
        return cell!
        
    }
    
}
