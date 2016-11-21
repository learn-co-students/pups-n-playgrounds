//
//  FirebaseData.swift
//  PupsAndPlaygrounds
//
//  Created by Robert Deans on 11/20/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import Firebase

class DataSomething {
    
    var ref: FIRDatabaseReference!
    
    func needFunction() {
        ref = FIRDatabase.database().reference()
        
    }
    
    var reviewTextBox: String?
    
    func addReview(with comment: String) {
        let ref = FIRDatabase.database().reference().root
        //        let key = ref.child("reviews").childByAutoId().key
        guard let userKey = FIRAuth.auth()?.currentUser?.uid else { return }
        
        ref.child("reviews").observeSingleEvent(of: .value, with: { snapshot in
            
            var count: String = "0"
            if let userDict = snapshot.value as? [String:Any] {
                if let reviewsDict = userDict[userKey] {
                    
                    count = String((reviewsDict as AnyObject).count)
                }
            }
            
            var newReview = [String:String]()
            
            if let reviewText = self.reviewTextBox {
                newReview[count] = "\(reviewText)"
                ref.child("reviews").child(userKey).updateChildValues(newReview)
            }
        })
    }
    
    
}
