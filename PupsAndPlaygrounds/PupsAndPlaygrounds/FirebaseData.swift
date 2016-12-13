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
    
    let newReview = Review(reviewID: uniqueReviewKey, userID: userUniqueID, locationID: locationID, rating: 5, comment: comment)
    
    return newReview
  }
  
  
  // MARK: Delete reviews
  
    
  
  
  // MARK Flag review or location
  
  
   
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
        guard let rating = value["rating"] as? Int else { print("rating = \(value["rating"])"); return }
        
        var reviewsIDArray = [String]()
        
        guard let latitude = Double(latitudeString) else { return }
        guard let longitude = Double(longitudeString) else { return }
        
        
        if let reviewsDictionary = value["reviews"] as? [String:Any] {
          for iterReview in reviewsDictionary {
            let reviewID = iterReview.key
            reviewsIDArray.append(reviewID)
          }
        }
        
        let newestPlayground = Playground(id: ID, name: locationName, address: address, isHandicap: isHandicap, latitude: latitude, longitude: longitude, reviewIDs: reviewsIDArray, rating: rating, photos: [], isFlagged:isFlagged)
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
  
  
  // MARK: Firebase real-time observer
  
  static func realtimeFirebaseObserver() {
    let ref = FIRDatabase.database().reference().child("reviews")
    
    ref.observe(FIRDataEventType.value, with: { (snapshot) in
      let postDict = snapshot.value as? [String : Any] ?? [:]
      
    })
  }
  
  
}



