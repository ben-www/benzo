//
//  JBenzoService.swift
//  BENZO
//
//  Created by Benjamin Weinstock on 12/22/20.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class JBenzoService {
    
    static func createJBenzoEntry(genrePercentages: [String : Double]) -> JBenzoData {
        
        var JBData = JBenzoData()
                
        let currentUser = Auth.auth().currentUser!.uid
        
        JBData.byId = currentUser
        JBData.hasJBenzo = true
        JBData.showJBenzo = true
        JBData.isGenreLocked = true
        JBData.genrePercentages = genrePercentages
        JBData.numOfMoviesRated = 0

        
        var metaData = [String:Any]()
        
        // Set metaData
        metaData["byId"] = currentUser
        metaData["hasJBenzo"] = true
        metaData["showJBenzo"] = true
        metaData["isGenreLocked"] = true
        metaData["numOfMoviesRated"] = 0
        
        metaData["swipedMovies"] = [String]()
        metaData["unswipedMovies"] = [String]()
        metaData["genrePercentages"] = genrePercentages
        metaData["JBenzoScores"] = [String:Double]()

        
        let db = Firestore.firestore()
        
        db.collection("JBenzoUserData").document(currentUser).setData(metaData)
        
        return JBData
        
    }
    
    
    
    
    // MARK: Load Functions
    static func retrieveJBenzoData(data:[Movie], completion: @escaping (JBenzoData?) -> Void) {
        
        // Check that there's a user logged in
        if Auth.auth().currentUser == nil {
            return
        }
        
        // Get the user id of the current User
        let userId = LocalStorageService.loadUserID()
        
        // Get a database reference
        let db = Firestore.firestore()
        
        

        db.collection("JBenzoUserData").document(userId!).getDocument { (snapshot, error) in
            // Check for errors
            if error != nil || snapshot == nil {
                // Something wrong happend
                return
            }

            if let profile = snapshot!.data() {
                // Profile was found, create NEW USER
                var JBD = JBenzoData()

                JBD.byId = profile["byId"] as? String
                JBD.hasJBenzo = profile["hasJBenzo"] as? Bool
                JBD.showJBenzo = profile["showJBenzo"] as? Bool
                JBD.isGenreLocked = profile["isGenreLocked"] as? Bool
                JBD.numOfMoviesRated = profile["numOfMoviesRated"] as? Int

                JBD.swipedMovies = profile["swipedMovies"] as? Array<String>
                JBD.unswipedMovies = profile["unswipedMovies"] as? Array<String>
                JBD.genrePercentages = profile["genrePercentages"] as? [String:Double]
                JBD.JBenzoScores = profile["JBenzoScores"] as? [String:Double]


                // Calculate JBenzoScores using genre %s and
                if JBD.hasJBenzo! {
                    let JBenzoScores = self.getJBenzoScores(data: data, genrePercentages: JBD.genrePercentages!)
                    JBD.JBenzoScores = JBenzoScores
                    updateJBenzoScores(scoresDict: JBenzoScores)
                    
                }

                completion(JBD)
                // Return the User
            }
            else {
                // Couldn't get profile, NO PROFILE
                // return nil
                completion(nil)
            }
        }
        
    }
    
    
    
    // MARK: UPDATE Functions
    static func updateJBenzoScores(scoresDict:[String:Double]) {
        
        let docId = LocalStorageService.loadUserID()
        let db = Firestore.firestore()
        db.collection("JBenzoUserData").document(docId!).updateData(["JBenzoScores" : scoresDict])
        
    }
    
    
    static func updateShowJBenzo(flag:Bool) {
        let docId = LocalStorageService.loadUserID()
        let db = Firestore.firestore()
        db.collection("JBenzoUserData").document(docId!).updateData(["showJBenzo" : flag])
        
    }
    
    
    
    
    
    
    
    
    
    
    
    // MARK: JBENZO Calc Functions
    private static func getJBenzoScores(data:[Movie], genrePercentages:[String:Double]) -> [String:Double] {
        //print("Data: ",data)
        //print("g%: ",genrePercentages)
        var result = [String:Double]()
        
        for mov in data {
            
            let movieCats = createCatList(mov: mov)
            //print(mov.Title!, movieCats)
            var jbScore = 0.0
            
            if movieCats == nil {
                // Does the Movie have Categories?
                var temp = mov
                temp.jBENZO = mov.BENZO
                result[mov.Title!] = temp.jBENZO

            } else {
                // Yes, count the "," to pick JBenzo Algo
                let catArr = movieCats!.components(separatedBy: ",")

                jbScore = getJBENZOScore(mov: mov, genrePercentages: genrePercentages, catArr: catArr)
                var temp = mov
                temp.jBENZO = jbScore
                result[mov.Title!] = temp.jBENZO
            }
            
        }
        
        return result
    }
    
    
    static func createCatList(mov:Movie) -> String? {
        
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
    
    
    private static func getJBENZOScore(mov:Movie, genrePercentages:[String:Double], catArr: [String]) -> Double {
        var newScore:Double?
        var scoresArr = [Double]()

        for cat in catArr {
            let catTrimmed = cat.trimmingCharacters(in: .whitespaces)
            let genreScore = genrePercentages[catTrimmed]
            scoresArr.append(genreScore!)
        }

        scoresArr = scoresArr.sorted().reversed()


        if catArr.count == 1 {
            newScore = (scoresArr[0] * mov.BENZO! * 1.5)/100

        }

        if catArr.count == 2 {
            newScore = (scoresArr[0] * 0.7 + scoresArr[1] * 0.3) * mov.BENZO! * 1.5/100

        }

        if catArr.count == 3 {
            newScore = (scoresArr[0] * 0.7 + scoresArr[1] * 0.2 + scoresArr[2] * 0.1) * mov.BENZO! * 1.5/100


        }


        return newScore ?? 0.0
    }
    
}
