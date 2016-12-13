//
//  FIRClient.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 12/11/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import Firebase

final class FIRClient {
  
  // Firebase Root Reference
  static let ref = FIRDatabase.database().reference()
  
  // MARK: Create new user account
  static func createAccount(firstName: String, lastName: String, email: String, password: String, completion: @escaping () -> Void) {
    FIRAuth.auth()?.createUser(withEmail: email, password: password) { user, error in
      guard error == nil else {
        print("error creating firebase user")
        return
      }
      
      guard let user = user else {
        print("error unwrapping new user data")
        return
      }
      
      ref.child("users").updateChildValues([user.uid : ["firstName" : firstName, "lastName": lastName]])
    
      completion()
    }
  }
  
  // MARK: Existing User Login
  static func login(email: String, password: String, completion: @escaping () -> Void) {
    FIRAuth.auth()?.signIn(withEmail: email, password: password) { user, error in
      guard error == nil else {
        print("error signing user in")
        return
      }
      
      completion()
    }
  }
  
  // MARK: Retrieve existing user
  static func getUser(user: FIRUser?, completion: @escaping(User) -> Void) {
    guard let uid = user?.uid else {
      print("error unwrapping uid from user in FIRClient")
      return
    }
    
    ref.child("users").child(uid).observe(.value, with: { snapshot in
      guard let userInfo = snapshot.value as? [String : Any] else {
        print("error unwrapping user information")
        return
      }
      
      guard let firstName = userInfo["firstName"] as? String else {
        print("error unwrapping first name")
        return
      }
      
      guard let lastName = userInfo["lastName"] as? String else {
        print("error unwrapping last name")
        return
      }
      
      let user = User(uid: uid, firstName: firstName, lastName: lastName)
      
      if let reviewIDs = userInfo["reviewIDs"] as? [String] {
        user.reviewIDs = reviewIDs
      }
      
      if let profilePhotoURL = URL(string: userInfo["profilePhotoURLString"] as? String ?? "") {
        URLSession.shared.dataTask(with: profilePhotoURL) { data, response, error in
          guard let data = data else {
            print("error unwrapping data")
            return
          }
          
          user.profilePhoto = UIImage(data: data)
          completion(user)
          }.resume()
      } else {
        completion(user)
      }
    })
  }
  
  static func getReviews(forUser user: User?, completion: @escaping ([Review]) -> Void) {
    guard let user = user else {
      print("error unwrapping user while retrieving reviews")
      return
    }
    
    var reviews = [Review]()
    
    ref.child("reviews").child("visible").observe(.value, with: { snapshot in
      guard let reviewsDict = snapshot.value as? [String : [String : Any]] else {
        print("error unwrapping user reviews dict")
        return
      }
      
      for (reviewID, reviewInfo) in reviewsDict {
        guard user.reviewIDs.contains(reviewID) else { continue }
        guard let locationID = reviewInfo["locationID"] as? String else {
          print("error unwrapping location id from user review")
          return
        }
        
        guard let rating = reviewInfo["rating"] as? Int else {
          print("error unwrapping rating from user review")
          return
        }
        
        guard let comment = reviewInfo["comment"] as? String else {
          print("error unwrapping comment from user review")
          return
        }
        
        reviews.append(Review(reviewID: reviewID, userID: user.uid, locationID: locationID, rating: rating, comment: comment))
      }
      
      completion(reviews)
    })
  }
  
  static func getReview(with reviewID: String, completion: @escaping (Review) -> ()) {
    let ref = FIRDatabase.database().reference().root
    
    let userKey = ref.child("reviews").child("visible").child(reviewID)
    
    userKey.observeSingleEvent(of: .value, with: { (snapshot) in
      guard let reviewDict = snapshot.value as? [String : Any] else { print("REVIEWDICTIONARY = \(snapshot.value as? [String : Any]): review was flagged"); return }
      guard let comment = reviewDict["comment"] as? String else { print("ERROR #2 \(reviewDict["comment"])"); return }
      guard let userID = reviewDict["userID"] as? String else { print("ERROR #3"); return }
      guard let locationID = reviewDict["locationID"] as? String else { print("ERROR #4"); return }
      
      let newReview = Review(reviewID: reviewID, userID: userID, locationID: locationID, rating: 0, comment: comment)
      
      completion(newReview)
    })
  }
  
  static func saveProfilePhoto(completion: @escaping () -> Void) {
    guard let user = DataStore.shared.user else {
      print("error unwrapping user on profile photo save")
      return
    }
    
    guard let profilePhoto = user.profilePhoto else {
      print("error unwrapping user profile photo on save")
      return
    }
    
    let profilePhotoID = NSUUID().uuidString
    let storageRef = FIRStorage.storage().reference().child("profilePhotos").child("\(profilePhotoID).png")
    
    if let profilePhotoPNG = UIImagePNGRepresentation(profilePhoto) {
      storageRef.put(profilePhotoPNG, metadata: nil) { metadata, error in
        if let error = error {
          print(error)
          return
        }
        
        guard let metadataURLString = metadata?.downloadURL()?.absoluteString else {
          print("no profile image URL")
          return
        }
        
        ref.child("users").child(user.uid).updateChildValues(["profilePhotoURLString" : metadataURLString])
        
        completion()
      }
    }
  }
  
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
      
      var reviewsIDArray = [String]()
      
      
      guard let latitude = Double(latitudeString) else { return }
      guard let longitude = Double(longitudeString) else { return }
      
      
      if let reviewsDictionary = locationDict["reviews"] as? [String : Any] {
        for iterReview in reviewsDictionary {
          let reviewID = iterReview.key
          reviewsIDArray.append(reviewID)
        }
      }
      
      let newestPlayground = Playground(id: locationID, name: name, address: address, isHandicap: isHandicap, latitude: latitude, longitude: longitude, reviewIDs: reviewsIDArray, photos: [], isFlagged:isFlagged)
      
      completion(newestPlayground)
    })
    
  }
  
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
  
  static func deleteUsersOwnReview(userID: String, reviewID: String, locationID: String, completion: () -> ()) {
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
}




