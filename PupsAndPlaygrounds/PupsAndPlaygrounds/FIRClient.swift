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
      guard error == nil else { print("error creating firebase user"); return }
      guard let user = user else { print("error unwrapping new user data"); return }
      
      ref.child("users").updateChildValues([user.uid : ["firstName" : firstName,
                                                        "lastName": lastName,
                                                        "email": email,
                                                        "password": password]])
      
      completion()
    }
  }
  
  // MARK: Existing User Login
  static func login(email: String, password: String) {
    FIRAuth.auth()?.signIn(withEmail: email, password: password) { user, error in
      guard error == nil else { print("error signing user in"); return }
    }
  }
  
  // MARK: Retrieve existing user
  static func getUser(firUser: FIRUser?, completion: @escaping(User) -> Void) {
    guard let uid = firUser?.uid else { print("error unwrapping firUser uid"); return }
    
    ref.child("user").child(uid).observeSingleEvent(of: .value, with: { snapshot in
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
      
      if let profilePhotoURL = URL(string: userInfo["profilePicURL"] as? String ?? "") {
        URLSession.shared.dataTask(with: profilePhotoURL) { data, response, error in
          guard let data = data else { print("error unwrapping data"); return }
          user.profilePhoto = UIImage(data: data)
          }.resume()
      }
      
      completion(user)
    })
  }
  
  
  static func addReview() {
    
  }
}




