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
    
    var ref: FIRDatabaseReference!
    
    func needFunction() {
        ref = FIRDatabase.database().reference()
        
    }
    
    
    
    class func createAccountTouched(firstName: String, lastName: String, email:String, password: String, checkedPassword:String) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { user, error in
            
            guard error == nil else { print("error creating firebase user; Error: \(error)"); return }
            guard let user = user else { print("error unwrapping user data"); return }
            
            let changeRequest = user.profileChangeRequest()
            changeRequest.displayName = firstName + lastName
            
            changeRequest.commitChanges { error in
                
                guard error == nil else { print("error commiting changes for user profile change request"); return }
                
            }
        }
    }
    
    
    
    
    func signIn(email: String, password: String) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { user, error in
            
            guard error == nil else { print("error signing user in"); return }
            
        }
    }
    
    func addReview(with comment: String, rating: String, locationID: String) {
        let ref = FIRDatabase.database().reference().root
        
        let uniqueReviewKey = FIRDatabase.database().reference().childByAutoId().key
        
        guard let userKey = FIRAuth.auth()?.currentUser?.uid else { return }
        
        ref.child("reviews").updateChildValues([uniqueReviewKey: ["comment": comment, "rating": rating, "userID": userKey, "locationID": locationID]])
        
    }
    
    func addPlaygrounds(playgroundID: String, name: String, location: String, isHandicap: Bool, latitude: String, longitude: String) {

        let ref = FIRDatabase.database().reference().root
        
        let uniqueLocationKey = playgroundID
        
        var isHandicapString = "No"
        
        if isHandicap == true {
            isHandicapString = "Yes"
        }
        
        ref.child("locations").child("playgrounds").updateChildValues( [uniqueLocationKey:["name": name, "location": location, "isHandicap": isHandicapString, "latitude": latitude, "longitude": longitude]])
    }
    
    func addDogruns(dogRunID: String, name: String, location: String, isHandicap: Bool, dogRunType: String, notes: String) {
        
        let ref = FIRDatabase.database().reference().root
        
        let uniqueLocationKey = dogRunID
        
        var isHandicapString = "No"
        
        if isHandicap == true {
            isHandicapString = "Yes"
        }
        
        ref.child("locations").child("dogruns").updateChildValues( [uniqueLocationKey:["name": name, "location": location, "isHandicap": isHandicapString, "dogRunType": dogRunType, "notes": notes]])
    }
}
