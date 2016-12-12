//
//  FirebaseData.swift
//  PupsAndPlaygrounds
//
//  Created by Robert Deans on 11/20/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import Firebase

class FirebaseData {
    
    
    // MARK: Account Creation
    
    static func createAccountTouched(firstName: String, lastName: String, email:String, password: String, checkedPassword:String) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { user, error in
            
            guard error == nil else { print("error creating firebase user; Error: \(error)"); return }
            guard let user = user else { print("error unwrapping user data"); return }
            
            let changeRequest = user.profileChangeRequest()
            changeRequest.displayName = firstName + lastName
            
            changeRequest.commitChanges { error in
                
                guard error == nil else { print("error commiting changes for user profile change request"); return }
                
            }
        }
        
//        addUserToBranch(firstName: firstName, lastName: lastName, email: email, password: password)
      
    }
    
        
    
    static func signIn(email: String, password: String) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { user, error in
            
            guard error == nil else { print("error signing user in"); return }
            
        }
    }
    
    // MARK: Get single user/review/location with uniqueID
    
    
    static func getUser(with userID: String, completion: @escaping (User?) -> ()) {
        let ref = FIRDatabase.database().reference().root
        
        let userKey = ref.child("users").child(userID)
        
        userKey.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDict = snapshot.value as? [String : Any] else { return }
            
            guard let firstName = userDict["firstName"] as? String else { return }
            guard let lastName = userDict["lastName"] as? String else { return }
            
            var reviewsArray = [String]()
            
            if let reviewsDictionary = userDict["reviews"] as? [String:Any] {
                for iterReview in reviewsDictionary {
                    guard let reviewID = iterReview.key as? String else { return }
                    reviewsArray.append(reviewID)
                }
            }
//            let newestUser = User(userID: userID, firstName: firstName, lastName: lastName, reviewsID: reviewsArray)
//            completion(newestUser)
        })
    }
    
//    static func getReview(with reviewID: String, completion: @escaping (Review) -> ()) {
//        let ref = FIRDatabase.database().reference().root
//        
//        let userKey = ref.child("reviews").child("visible").child(reviewID)
//        
//        userKey.observeSingleEvent(of: .value, with: { (snapshot) in
//            guard let reviewDict = snapshot.value as? [String : Any] else { print("REVIEWDICTIONARY = \(snapshot.value as? [String : Any]): review was flagged"); return }
//            guard let comment = reviewDict["comment"] as? String else { print("ERROR #2 \(reviewDict["comment"])"); return }
//            guard let userID = reviewDict["userID"] as? String else { print("ERROR #3"); return }
//            guard let locationID = reviewDict["locationID"] as? String else { print("ERROR #4"); return }
//            
//            let newReview = Review(userID: userID, locationID: locationID, comment: comment, photos: [], reviewID: reviewID)
//            
//            completion(newReview)
//        })
//    }
  
    
    static func getLocation(with locationID: String, completion: @escaping (Location?) -> ()) {
        
        let ref = FIRDatabase.database().reference().root
        
        let locationKey = ref.child("locations").child("playgrounds").child(locationID)
        
        locationKey.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let locationDict = snapshot.value as? [String : Any] else { print("ERROR #1"); return }
            guard let name = locationDict["name"] as? String else { print("ERROR #2"); return }
            guard let address = locationDict["address"] as? String else { print("ERROR #3"); return }
            guard let latitudeString = locationDict["latitude"] as? String else { print("ERROR #4"); return }
            guard let longitudeString = locationDict["longitude"] as? String else { print("ERROR #5"); return }
            guard let isHandicap = locationDict["isHandicap"] as? String else { print("ERROR #6"); return }
            guard let isFlagged = locationDict["isFlagged"] as? String else { print("ERROR #7"); return }
            //            guard let photos = locationDict["photos"] as? [UIImage] else { return }
            
            var reviewsIDArray = [String?]()
            
            
            guard let latitude = Double(latitudeString) else { return }
            guard let longitude = Double(longitudeString) else { return }
            
            
            if let reviewsDictionary = locationDict["reviews"] as? [String:Any] {
                for iterReview in reviewsDictionary {
                    let reviewID = iterReview.key
                    reviewsIDArray.append(reviewID)
                }
            }
            
            let newestPlayground = Playground(ID: locationID, name: name, address: address, isHandicap: isHandicap, latitude: latitude, longitude: longitude, reviewsID: reviewsIDArray, photos: [], isFlagged:isFlagged)
            
            completion(newestPlayground)
        })
        
    }
    
    
    // MARK: Adds Review
    
    static func addReview(comment: String, locationID: String, rating: String) -> Review? {
        let ref = FIRDatabase.database().reference().root
        
        let uniqueReviewKey = FIRDatabase.database().reference().childByAutoId().key
        
        guard let userUniqueID = FIRAuth.auth()?.currentUser?.uid else { return nil }
        
        if locationID.hasPrefix("PG") {
            
            ref.child("locations").child("playgrounds").child("\(locationID)").child("reviews").updateChildValues([uniqueReviewKey: ["flagged": "false", "rating": rating]])
            
        } else if locationID.hasPrefix("DR") {
            
            ref.child("locations").child("dogruns").child("\(locationID)").child("reviews").updateChildValues([uniqueReviewKey: ["flagged": "false", "rating": rating]])
        }
        
        ref.child("users").child("\(userUniqueID)").child("reviews").updateChildValues([uniqueReviewKey: ["flagged": "false"]])
        
        ref.child("reviews").child("visible").updateChildValues([uniqueReviewKey: ["comment": comment, "userID": userUniqueID, "locationID": locationID, "flagged": "false", "reviewID": uniqueReviewKey]])
        
        let newReview = Review(userID: userUniqueID, locationID: locationID, comment: comment, photos: [], reviewID: uniqueReviewKey)
        
        return newReview
        
    }
    
    
    // MARK: Delete reviews
    
    static func deleteUsersOwnReview(userID: String, reviewID: String, locationID: String, completion: () -> ()) {
        print("DELETE IS RUNNING!")
        print("USER ID IS \(userID)")

        print("REVIEW ID IS \(reviewID)")

        print("LOCATION ID IS \(locationID)")

        let ref = FIRDatabase.database().reference().root
        
        guard let userUniqueID = FIRAuth.auth()?.currentUser?.uid else { return }
        
        print("CURRENT USER ID IS \(userUniqueID)")
        
        if userID == userUniqueID {
            
            if locationID.hasPrefix("PG") {
                
                ref.child("locations").child("playgrounds").child("\(locationID)").child("reviews").child(reviewID).removeValue()
                
            } else if locationID.hasPrefix("DR") {
                
                ref.child("locations").child("dogruns").child("\(locationID)").child("reviews").child(reviewID).removeValue()
            }
            
            ref.child("users").child("\(userUniqueID)").child("reviews").child(reviewID).removeValue()
            
            
            ref.child("reviews").child("visible").child(reviewID).removeValue()
            
        }
    completion()
    }
    
    static func deleteCommentAdmin(userID: String, reviewID: String, locationID: String, completion: () -> ()) {
        
        let ref = FIRDatabase.database().reference().root
        
        guard let userUniqueID = FIRAuth.auth()?.currentUser?.uid else { return }
        
        
        if locationID.hasPrefix("PG") {
            
            ref.child("locations").child("playgrounds").child("\(locationID)").child("reviews").child(reviewID).removeValue()
            
        } else if locationID.hasPrefix("DR") {
            
            ref.child("locations").child("dogruns").child("\(locationID)").child("reviews").child(reviewID).removeValue()
        }
        
        ref.child("users").child("\(userUniqueID)").child("reviews").child(reviewID).removeValue()
        
        
        ref.child("reviews").child("visible").child(reviewID).removeValue()
        
        completion()
        
    }
    
    
    // MARK Flag review or location
    
    
    static func flagReviewWith(unique reviewID: String, locationID: String, comment: String, userID: String, completion: () -> Void) {
        let rootRef = FIRDatabase.database().reference().root
        
        let reviewRef = rootRef.child("reviews")
        
        guard let userUniqueID = FIRAuth.auth()?.currentUser?.uid else { return }
        
        if locationID.hasPrefix("PG") {
            
            rootRef.child("locations").child("playgrounds").child("\(locationID)").child("reviews").updateChildValues([reviewID: ["flagged": true]])
            
        } else if locationID.hasPrefix("DR") {
            
            rootRef.child("locations").child("dogruns").child("\(locationID)").child("reviews").updateChildValues([reviewID: ["flagged": true]])
        }
        
        rootRef.child("users").child("\(userUniqueID)").child("reviews").updateChildValues([reviewID: ["flagged": true]])
        
        
        reviewRef.child("flagged").updateChildValues([reviewID: ["comment": comment, "userID": userID, "locationID": locationID, "flagged": true]])
        
        reviewRef.child("visible").child(reviewID).removeValue()
        completion()
    }
    
    // MARK: Generates Locations on the app FROM Firebase data source
    
    static func getAllPlaygrounds(with completion: @escaping ([Playground]) -> Void ) {
        
        var playgroundArray: [Playground] = []
        
        let ref = FIRDatabase.database().reference().child("locations").child("playgrounds")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let playgroundDict = snapshot.value as? [String : Any] else { return }
            
            for newPlayground in playgroundDict {
                
                let ID = newPlayground.key
                let value = newPlayground.value as! [String:Any]
                guard let locationName = value["name"] as? String else { print("locationName \(value["name"])"); return }
                guard let address = value["address"] as? String else { print("address \(value["address"])"); return }
                guard let latitudeString = value["latitude"] as? String else { print("latitude \(value["latitude"])"); return }
                guard let longitudeString = value["longitude"] as? String else { print("longitude = \(value["longitude"])"); return }
                guard let isHandicap = value["isHandicap"] as? String else { print("isHandicap = \(value["isHandicap"])"); return }
                guard let isFlagged = value["isFlagged"] as? String else { print("isFlagged = \(value["isFlagged"])"); return }
                
                var reviewsIDArray = [String?]()
                
                guard let latitude = Double(latitudeString) else { return }
                guard let longitude = Double(longitudeString) else { return }
                
                
                if let reviewsDictionary = value["reviews"] as? [String:Any] {
                    for iterReview in reviewsDictionary {
                        let reviewID = iterReview.key
                        reviewsIDArray.append(reviewID)
                    }
                }
                
                let newestPlayground = Playground(ID: ID, name: locationName, address: address, isHandicap: isHandicap, latitude: latitude, longitude: longitude, reviewsID: reviewsIDArray, photos: [], isFlagged:isFlagged)
                playgroundArray.append(newestPlayground)
            }
            completion(playgroundArray)
            
        })
    }
    
    // MARK: Adding local JSON files to Firebase
    
    static func addPlaygroundsToFirebase(name: String, address: String, isHandicap: String, latitude: String, longitude: String) {
        
        let ref = FIRDatabase.database().reference().root
        
        let uniqueLocationKey = FIRDatabase.database().reference().childByAutoId().key
        
        ref.child("locations").child("playgrounds").updateChildValues(["PG-\(uniqueLocationKey)":["name": name, "address": address, "isHandicap": isHandicap, "latitude": latitude, "longitude": longitude, "isFlagged": "false"]])
    }
    
    static func addDogrunsToFirebase(name: String, address: String, isHandicap: String, dogRunType: String, notes: String) {
        
        let ref = FIRDatabase.database().reference().root
        
        let uniqueLocationKey = FIRDatabase.database().reference().childByAutoId().key
        
        ref.child("locations").child("dogruns").updateChildValues( ["DR-\(uniqueLocationKey)":["name": name, "location": address, "isHandicap": isHandicap, "dogRunType": dogRunType, "notes": notes, "isFlagged": "false"]])
    }
    
    
    // MARK: Get reviews exluding current users
    
    static func getVisibleReviewsForFeed(with completion: @escaping ([Review]) -> Void) {
        
        let reviewRef = FIRDatabase.database().reference().child("reviews").child("visible")
        var reviewsArray = [Review]()
        
        reviewRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshotValue = snapshot.value as? [String: Any] else {print("no reviews"); return}
            
            for review in snapshotValue {
                guard let reviewInfo = review.value as? [String: Any],
                    let comment = reviewInfo["comment"] as? String,
                    let flagged = reviewInfo["flagged"] as? Bool,
                    let locationID = reviewInfo["locationID"] as? String,
                    let reviewID = reviewInfo["reviewID"] as? String,
                    let userID = reviewInfo["userID"] as? String
                    else { print("no review data"); return }
                
                let reviewToAdd = Review(reviewID: reviewID, userID: userID, locationID: locationID, rating: 5, comment: comment)
                
                reviewsArray.append(reviewToAdd)
            }
            
            completion(reviewsArray)
            
        })
    }
    
    static func calcAverageStarFor(location uniqueID: String, completion: @escaping (Float) -> Void) {
        
        let ref = FIRDatabase.database().reference().child("locations")
        
        var playgroundRatings = [Double]()
        var playgroundRatingsSum = Double()
        var dogrunRatingsSum = Double()
        var dogrunRatings = [Double]()
        var averageStarValueToReturn = Float()
        
        if uniqueID.hasPrefix("PG") {
            
            ref.child("playgrounds").child("\(uniqueID)").child("reviews").observeSingleEvent(of: .value, with: { (snapshot) in
                guard let snapshotValue = snapshot.value as? [String: Any] else { print("error returning playground reviews"); return}
                
                for snap in snapshotValue {
                    guard let playgroundInfo = snap.value as? [String: Any] else {print("error returning playground info"); return}
                    guard let ratingString = playgroundInfo["rating"] as? String,
                        let rating = Double(ratingString) else { print("error returning rating string values"); return }
                    
                    playgroundRatings.append(rating)
                }
                
                for value in playgroundRatings {
                    playgroundRatingsSum += value
                }
                
                print("PLAYGROUND RATING SUM =\(playgroundRatingsSum)")
                print("PLAYGROUND RATING count =\(playgroundRatings.count)")
                
                averageStarValueToReturn = Float(playgroundRatingsSum / Double(playgroundRatings.count))
                print("AVERAGE STARS: \(averageStarValueToReturn)")
                completion(averageStarValueToReturn)
            })
            
        } else if uniqueID.hasPrefix("DR") {
            
            ref.child("dogruns").child("\(uniqueID)").child("reviews").observeSingleEvent(of: .value, with: { (snapshot) in
                guard let snapshotValue = snapshot.value as? [String: Any] else { print("error returning playground reviews"); return}
                
                for snap in snapshotValue {
                    guard let playgroundInfo = snap.value as? [String: Any] else {print("error returning playground info"); return}
                    guard let ratingString = playgroundInfo["rating"] as? String,
                        let rating = Double(ratingString) else { print("error returning rating string values"); return }
                    
                    playgroundRatings.append(rating)
                    
                    if playgroundRatings.count == snapshotValue.count {
                        for value in playgroundRatings {
                            playgroundRatingsSum += value
                        }
                        print("PLAYGROUND RATING SUM =\(playgroundRatingsSum)")
                        print("PLAYGROUND RATING count =\(playgroundRatings.count)")
                        
                        averageStarValueToReturn = Float(playgroundRatingsSum / Double(playgroundRatings.count))
                    }
                    
                }
                
                completion(averageStarValueToReturn)
            })
        }
        
        
        
    }
    
    // MARK: Firebase real-time observer
    
    static func realtimeFirebaseObserver() {
        let ref = FIRDatabase.database().reference().child("reviews")
        
        ref.observe(FIRDataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : Any] ?? [:]
            
        })
    }
    
    
}



