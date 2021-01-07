//
//  HomeViewController.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/3/20.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController, MovieDataProtocol {

    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var JBENZObutton: UIButton!
    @IBOutlet var popoverView: UIView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    
    var blurEffectView = UIVisualEffectView()
    
    var movieData = MovieData()
    var data = [Movie]()
    var searching = false
    
    var jBenzoData:JBenzoData?
    var watchData:WatchData?
    var friendListData:FriendListData?

    
    var filteredData = [Movie]()
    var filtering = false

    
    var pickerData: [String] = [String]()
    var genre = "BENZO"


    //var JBENZOData = [Movie]()
    
    //var rank = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // Connect data:
        self.picker.delegate = self
        self.picker.dataSource = self

        profileButton.layer.shadowColor = UIColor.black.cgColor
        profileButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        profileButton.layer.shadowOpacity = 1.0
        profileButton.layer.shadowRadius = 3

        
        
        
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


        UserService.retrieveFriendListData { (retrievedData) in
            // Get the Users WatchedData
            self.friendListData = retrievedData
            
            if self.friendListData == nil {
                self.friendListData = UserService.createFriendListEntry()
            }
        }
        
        
        JBenzoService.retrieveJBenzoData(data: self.data) { (retrievedData) in
            self.jBenzoData = retrievedData
            self.data.sort(by: { $0.BENZO! > $1.BENZO! })

            
            
            // Has and show should have different if Statments ***!!!
            
            if self.jBenzoData != nil && ((self.jBenzoData?.hasJBenzo) != nil){
                for (index, mov) in self.data.enumerated() {
                    
                    let title = mov.Title
                    self.data[index].jBENZO = self.jBenzoData?.JBenzoScores![title!]
                }
            }
            
            if self.jBenzoData != nil && ((self.jBenzoData?.hasJBenzo) != nil) && (((self.jBenzoData?.showJBenzo)!)) {
                
                self.data.sort(by: { $0.jBENZO! > $1.jBENZO! })
                self.JBENZObutton.setImage(UIImage(systemName: "j.circle.fill"), for: .normal)
            }
            
            self.tableView.reloadData()
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("Works")
        
        JBenzoService.retrieveJBenzoData(data: self.data) { (retrievedData) in
            self.jBenzoData = retrievedData
            self.data.sort(by: { $0.BENZO! > $1.BENZO! })

            if self.jBenzoData != nil && ((self.jBenzoData?.hasJBenzo) != nil) && (((self.jBenzoData?.showJBenzo)!)) {

                for (index, mov) in self.data.enumerated() {
                    
                    let title = mov.Title
                    self.data[index].jBENZO = self.jBenzoData?.JBenzoScores![title!]
                }
                
                
                self.data.sort(by: { $0.jBENZO! > $1.jBENZO! })
                self.JBENZObutton.setImage(UIImage(systemName: "j.circle.fill"), for: .normal)
            }
            
            self.tableView.reloadData()
            
        }
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
        temp[0] = "BENZO"
        
        return temp
        
    }
    
    
    func buildFilteredData() {
        var temp = [Movie]()
        
        
        for mov in self.data {
            if mov.Category1 == self.genre || mov.Category2 == self.genre || mov.Category3 == self.genre {
                temp.append(mov)
            }
        }
        
        self.filteredData = temp
        self.filteredData.sort(by: { $0.BENZO! > $1.BENZO! })
        
        if self.jBenzoData != nil && ((self.jBenzoData?.hasJBenzo) != nil) && (((self.jBenzoData?.showJBenzo)!)) {
            print("Filtering w/ Jbenzo")
            self.filteredData.sort(by: { $0.jBENZO! > $1.jBENZO! })
        }

        print("TEST")
    }
    
    
    
    
    @objc func refreshFeed(refreshControl: UIRefreshControl) {
        
        self.filtering = false
        // Call the photo service
        
        self.title = "BENZO"
        self.JBENZObutton.setImage(UIImage(systemName: "j.circle"), for: .normal)
        self.data.sort(by: { $0.BENZO! > $1.BENZO! })

        
        if self.jBenzoData != nil && ((self.jBenzoData?.hasJBenzo) != nil) && (((self.jBenzoData?.showJBenzo)!)) {
            self.JBENZObutton.setImage(UIImage(systemName: "j.circle.fill"), for: .normal)
            self.data.sort(by: { $0.jBENZO! > $1.jBENZO! })


        }
        
        

        self.tableView.reloadData()

        // Stop the spinner
        refreshControl.endRefreshing()

    }
    

    
    // MARK: Prepare Actions

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.profileSettings {
            let profileVC = segue.destination as! ProfileSettingsViewController
            profileVC.data = self.data
            profileVC.jBenzoData = self.jBenzoData

            
            print("prepare func profileSettings")
        }
        
        if segue.identifier == Constants.Segue.genreCalculator {
            let getGenrePercentagesVC = segue.destination as! GetGenrePercentagesViewController
            getGenrePercentagesVC.genres = self.pickerData
            
            for mov in self.data {
                getGenrePercentagesVC.movies.append(mov.Title!)
            }
            

        }
        
        if segue.identifier == Constants.Segue.jBenzoSwipe {
            let swipeVC = segue.destination as! JBenzoSwipeViewController
            swipeVC.data = self.data
            swipeVC.genres = self.pickerData
            swipeVC.jBenzoData = self.jBenzoData
        }

        
        if segue.identifier == "search" {
            let searchViewController = segue.destination as! SearchViewController
            searchViewController.data = self.data
            searchViewController.jBenzoData = self.jBenzoData

        
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
    
    
    // MARK: J Benzo Toggle Msg
    func showToggleAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            if self.jBenzoData != nil && ((self.jBenzoData?.hasJBenzo) != nil) && (((self.jBenzoData?.showJBenzo)!)) {
                print("Toggled Off")
                self.data.sort(by: { $0.BENZO! > $1.BENZO! })
                self.jBenzoData?.showJBenzo = false
                self.JBENZObutton.setImage(UIImage(systemName: "j.circle"), for: .normal)

                // update in Firestore db
                JBenzoService.updateShowJBenzo(flag: false)
                
                self.filteredData.sort(by: { $0.BENZO! > $1.BENZO! })
                self.tableView.reloadData()

            }
            else if self.jBenzoData != nil && ((self.jBenzoData?.hasJBenzo) != nil) && (!((self.jBenzoData?.showJBenzo)!)) {
                print("Toggled On")
                for (index, mov) in self.data.enumerated() {
                    
                    let title = mov.Title
                    self.data[index].jBENZO = self.jBenzoData?.JBenzoScores![title!]
                }
                
                
                self.data.sort(by: { $0.jBENZO! > $1.jBENZO! })
                self.jBenzoData?.showJBenzo = true
                self.JBENZObutton.setImage(UIImage(systemName: "j.circle.fill"), for: .normal)

                // update in Firestore db
                JBenzoService.updateShowJBenzo(flag: true)

                self.filteredData.sort(by: { $0.jBENZO! > $1.jBENZO! })
                self.tableView.reloadData()


            }

        }
        
        alert.addAction(yesAction)

        
        let noAction = UIAlertAction(title: "No", style: .default) { (action) in
        }
        
        let swipeSegue = UIAlertAction(title: "Enhance", style: .default) { (action) in
            if self.jBenzoData != nil && ((self.jBenzoData?.hasJBenzo) != nil) {
                self.performSegue(withIdentifier: Constants.Segue.jBenzoSwipe, sender: nil)

            }
        }
        
        alert.addAction(noAction)
        
        if self.jBenzoData != nil && ((self.jBenzoData?.hasJBenzo) != nil) && (((self.jBenzoData?.showJBenzo)!)) {
            alert.addAction(swipeSegue)

        }

        // Show Alert
        present(alert, animated: true, completion: nil)
        
    }
    

    // MARK: J Benzo Tapped
    @IBAction func JBENZOtapped(_ sender: Any) {
        if self.jBenzoData != nil && ((self.jBenzoData?.hasJBenzo) != nil) && (((self.jBenzoData?.showJBenzo)!))  {
            //print("Toggled On")
            showToggleAlert(title: "Turn OFF JBENZO", message: "JBENZO is 'ON' would you like to no longer view JBENZO scores?")

            return
        }
        else if self.jBenzoData != nil && ((self.jBenzoData?.hasJBenzo) != nil) && (!((self.jBenzoData?.showJBenzo)!)) {
            //print("Toggled Off")
            showToggleAlert(title: "Turn ON JBENZO", message: "BENZO is 'OFF' would you like to view JBENZO scores?")
            return
        }
        
        
        if self.jBenzoData == nil {
            self.performSegue(withIdentifier: Constants.Segue.genreCalculator, sender: nil)
        }

        
    }
    
    
    




    
    
    @IBAction func profileTapped(_ sender: Any) {
        //showSignOutAlert(title: "Sign Out", message: "Are you sure?")
        //self.performSegue(withIdentifier: Constants.Segue.genreCalculator, sender: nil)

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
        
        if self.genre == "BENZO" {
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
            
            if self.jBenzoData != nil && ((self.jBenzoData?.hasJBenzo) != nil) && (((self.jBenzoData?.showJBenzo)!)) {
              
                if let score = movie?.jBENZO {
                    let finalScore = round(10000.0 * score) / 10000.0
                    cell?.displayMovieTitle(title:(movie?.Title!)!, rank: String(finalScore),jBenzo: true)
                }
            }

            //self.rank += 1
        }
        return cell!
        
    }
    
}
