//
//  HomeViewController.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/3/20.
//

import UIKit

class HomeViewController: UIViewController, MovieDataProtocol {

    
    @IBOutlet weak var JBENZObutton: UIButton!
    @IBOutlet var popoverView: UIView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var blurEffectView = UIVisualEffectView()

    
    var movieData = MovieData()
    var data = [Movie]()
    var searching = false

    
    var filteredData = [Movie]()
    var filtering = false

    
    var ratings: [String:Double] = [:]
    var pickerData: [String] = [String]()
    var genre = "All"

//
//    var JBENZOData = [Movie]()
//    var jBENZO = false
    
    //var rank = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // Connect data:
        self.picker.delegate = self
        self.picker.dataSource = self
        
        addRefreshControl()

        self.popoverView.layer.cornerRadius = 24
        self.popoverView.layer.shadowColor = UIColor.black.cgColor
        self.popoverView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.popoverView.layer.shadowOpacity = 0.2
        self.popoverView.layer.shadowRadius = 4.0
        

        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        self.blurEffectView.effect = blurEffect
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                
        
        
        movieData.delegate = self
        
        movieData.getMovieData()
        pickerData = getGenres()
        
        
//        // J-Benzo is ACTIVE: calculate (JBENZOData) using (self.ratings)
//        if  self.jBENZO == true && self.JBENZObutton.currentImage == UIImage(systemName: "j.circle") {
//            self.JBENZObutton.setImage(UIImage(systemName: "j.circle.fill"), for: .normal)
//            self.JBENZObutton.isEnabled = false
//            self.data = getJBENZOdata()
//
//            self.data.sort(by: { $0.jBENZO! > $1.jBENZO! })
//
//        }
        
        

    }
    
    func addRefreshControl() {
        
        // Create refresh control
        let refresh = UIRefreshControl()
        
        // Set target
        refresh.addTarget(self, action: #selector(refreshFeed(refreshControl:)), for: .valueChanged)
        
        // Add to tableView
        self.tableView.addSubview(refresh)
    }

    
    // MARK: MovieData Delgate
    func moviesRetrieved(_ movies: [Movie]) {
        print("Movies: retrieved from the MovieData.")
        self.data = movies
        self.data.sort(by: { $0.BENZO! > $1.BENZO! })

        
    }
    
    
    
    // MARK: JBENZO Functions
//
//    func getJBENZOdata() -> [Movie] {
//        var newData = [Movie]()
//        //var catArr = [String]()
//
//        for mov in self.data {
//            let movieCats = createCatList(mov: mov)
//
//            // add JBENZO score to mov obj and and to data
//            var jbScore = 0.0
//
//
//            if movieCats == nil {
//                // Does the Movie have Categories?
//                var temp = mov
//                temp.jBENZO = temp.BENZO
//                newData.append(temp)
//
//            } else {
//                // Yes, count the "," to pick JBenzo Algo
//                let catArr = movieCats!.components(separatedBy: ",")
//
//                jbScore = getJBENZOScore(mov: mov, catArr: catArr)
//
//                print(mov.Title!,jbScore)
//                var temp = mov
//                temp.jBENZO = jbScore
//                newData.append(temp)
//
//            }
//
//
//        }
//        return newData
//
//    }
//
//
//
//    func getJBENZOScore(mov:Movie, catArr: [String]) -> Double {
//        var newScore:Double?
//        var scoresArr = [Double]()
//
//        for cat in catArr {
//            let catTrimmed = cat.trimmingCharacters(in: .whitespaces)
//            let genreScore = self.ratings[catTrimmed]
//            scoresArr.append(genreScore!)
//        }
//
//        scoresArr = scoresArr.sorted().reversed()
//
//
//        if catArr.count == 1 {
//            newScore = (scoresArr[0] * mov.BENZO! * 1.5)/100
//
//        }
//
//        if catArr.count == 2 {
//            newScore = (scoresArr[0] * 0.7 + scoresArr[1] * 0.3) * mov.BENZO! * 1.5/100
//
//        }
//
//        if catArr.count == 3 {
//            newScore = (scoresArr[0] * 0.7 + scoresArr[1] * 0.2 + scoresArr[2] * 0.1) * mov.BENZO! * 1.5/100
//
//
//        }
//
//
//        return newScore ?? 0.0
//    }
//
//
    
    
    // MARK: Filtering Functions

    
    func createCatList(mov:Movie) -> String? {
        
        var joinedCategories = [String]()

        if ((mov.Category1) == "") {
            return nil
        }
        if ((mov.Category2) == "") {
            return mov.Category1!
            
        }
        if ((mov.Category3) == "") {
            joinedCategories = [mov.Category1!, mov.Category2!]
            return joinedCategories.joined(separator: ", ")
            
        }
        else {
            joinedCategories = [mov.Category1!, mov.Category2!, mov.Category3!]
            return joinedCategories.joined(separator: ", ")
        }
        

    }
    
    
    
    func getGenres() -> [String] {
        var temp = [String]()

        for mov in self.data {
            temp.insert(mov.Category1!, at: 0)
            temp.insert(mov.Category2!, at: 0)
            temp.insert(mov.Category3!, at: 0)

        }
        
        temp = Array(Set(temp))
        temp.sort()
        temp[0] = "All"
        
//        if self.jBENZO {
//            temp.insert("J-Benzo", at: 1)
//        }
        
        return temp
        
    }
    
    
    func buildFilteredData() {
        if self.genre == "All" {
//            if self.jBENZO {
//                self.data.sort(by: { $0.jBENZO! > $1.jBENZO! })
//            }
//
            return
        }
        
        var temp = [Movie]()
        
        
        for mov in self.data {
            if mov.Category1 == self.genre || mov.Category2 == self.genre || mov.Category3 == self.genre {
                temp.append(mov)
            }
        }
        
        self.filteredData = temp
        self.filteredData.sort(by: { $0.BENZO! > $1.BENZO! })
        
//        if self.jBENZO {
//            self.filteredData.sort(by: { $0.jBENZO! > $1.jBENZO! })
//        }
        

        print("TEST")
    }
    
    
    
    
    @objc func refreshFeed(refreshControl: UIRefreshControl) {
        
        self.filtering = false
        // Call the photo service
        
        self.title = "BENZO"
        
//        self.jBENZO = false
        self.JBENZObutton.setImage(UIImage(systemName: "j.circle"), for: .normal)
        self.JBENZObutton.isEnabled = true
        
        self.data.sort(by: { $0.BENZO! > $1.BENZO! })

        self.tableView.reloadData()

        // Stop the spinner
        refreshControl.endRefreshing()

    }
    

    
    // MARK: Prepare Actions

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "jBenzo" {
            let jBenzoVC = segue.destination as! JBenzoSwipeViewController
            jBenzoVC.data = self.data
            jBenzoVC.genres = self.pickerData
        }
        
        if segue.identifier == "search" {
            let searchViewController = segue.destination as! SearchViewController
            searchViewController.data = self.data
        
        }
        
        if segue.identifier == "movieInfo" {
            
            if self.filtering {
                let movieInfoController = segue.destination as! MovieInfoViewController
                
                if tableView.indexPathForSelectedRow != nil {
                    // pass on movie
                    let index = self.data.firstIndex(where: { $0.Title == data[tableView.indexPathForSelectedRow!.row].Title })
                    movieInfoController.rank = Int(index!) + 1
                    movieInfoController.movie = filteredData[tableView.indexPathForSelectedRow!.row]
                    movieInfoController.data = self.data
                    tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
                }
            }
            else
            {
                
                let movieInfoController = segue.destination as! MovieInfoViewController
                
                if tableView.indexPathForSelectedRow != nil {
                    // pass on movie
                    let index = self.data.firstIndex(where: { $0.Title == data[tableView.indexPathForSelectedRow!.row].Title })
                    movieInfoController.rank = Int(index!) + 1
                    movieInfoController.movie = data[tableView.indexPathForSelectedRow!.row]
                    movieInfoController.data = self.data
                    tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
                }
            }
            
        }
        
        
    }
    
    
    
    
    // MARK: Button Tapped Functions

    @IBAction func JBENZOtapped(_ sender: Any) {
        
        if self.JBENZObutton.currentImage == UIImage(systemName: "j.circle") {
            self.JBENZObutton.isEnabled = false
            self.JBENZObutton.setImage(UIImage(systemName: "j.circle.fill"), for: .normal)
//            self.jBENZO = true
            
            // Reload Table
            self.tableView.reloadData()
            return
        }
        else {
//            self.jBENZO = false

            self.JBENZObutton.setImage(UIImage(systemName: "j.circle"), for: .normal)
            self.tableView.reloadData()

        }
        
 
    }
    
    
    
    // MARK: Search Buttons
    @IBAction func searchTapped(_ sender: Any) {
        self.searching = true
    }
    
    
    
    
    // MARK: Fitler Buttons
    @IBAction func filterTapped(_ sender: Any) {
        

        self.blurEffectView.alpha = 0.5
        print("FIlter Tapped")
        self.view.addSubview(self.blurEffectView)
        self.view.addSubview(self.popoverView)
        popoverView.center = self.view.center
        
        
    }
    
    
    @IBAction func doneTapped(_ sender: Any) {
        //print(self.genre)
        self.filtering = true
        
        if self.genre == "All" {
            self.filtering = false
            self.title = "BENZO"
        }
        
        // Build filteredData
        buildFilteredData()
        
        //print(self.genre, self.filtering)
        
        self.popoverView.removeFromSuperview()
        self.blurEffectView.removeFromSuperview()
        
        self.title = self.genre
        tableView.reloadData()

    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.popoverView.removeFromSuperview()
        self.blurEffectView.removeFromSuperview()
        
    }
    
}



// MARK: UIPickerViewDelegate, UIPickerViewDataSource
extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        self.genre = pickerData[row]


    }
    
    
    
}





// MARK: UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.filtering {
            return self.filteredData.count
        }
        else {
            return self.data.count

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.movieCellId , for: indexPath) as? MovieCell
        

        var movie:Movie?
        
        if self.filtering {
            movie = self.filteredData[indexPath.row]
        }
        else {
            movie = self.data[indexPath.row]
            
        }
                
        
        if movie != nil {
            cell?.displayMovieTitle(title:(movie?.Title!)!, rank: String((movie?.BENZO!)!))
//            if self.jBENZO {
//                if let score = movie?.jBENZO {
//                    let finalScore = round(10000.0 * score) / 10000.0
//
//                    cell?.displayMovieTitle(title:(movie?.Title!)!, rank: String(finalScore),jBenzo: true)
//                }
//            }
            //self.rank += 1
        }
        return cell!
        
    }
    
}
