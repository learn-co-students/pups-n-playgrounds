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
      
      ref.child("users").updateChildValues([user.uid : ["firstName" : firstName,
                                                        "lastName": lastName,
                                                        "email": email,
                                                        "password": password]])
    
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
        
//        guard let rating = reviewInfo["rating"] as? Int else {
//          print("error unwrapping rating from user review")
//          return
//        }
        
        guard let comment = reviewInfo["comment"] as? String else {
          print("error unwrapping comment from user review")
          return
        }
        
        reviews.append(Review(reviewID: reviewID, userID: user.uid, locationID: locationID, rating: 5, comment: comment))
      }
      
      completion(reviews)
    })
  }
  
  static func saveProfilePhoto(completion: @escaping () -> Void) {
    guard let user = WSRDataStore.shared.user else {
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
  
  static func addReview() {
    
  }
}




