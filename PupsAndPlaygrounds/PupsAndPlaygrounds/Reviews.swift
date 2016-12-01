//
//  Reviews.swift
//  PupsAndPlaygrounds
//
//  Created by Robert Deans on 11/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import UIKit

class Review {
    weak var user: User?
    weak var location: Location?
    let comment: String
    // let rating: Int
    var photos: [UIImage?]
    
    init(firebaseData: [String : Any], handler: @escaping (Bool) -> Void) {
        self.comment = firebaseData["comment"] as! String
        self.photos = []
        let userID = firebaseData["userID"] as! String
        let locationID = firebaseData["locationID"] as! String

        FirebaseData.getUser(with: userID, completion: { user in
            
            self.user = user
            
            FirebaseData.getLocation(with: locationID) { location in
                
                self.location = location
                
                handler(true)
                
            }
            
        })
        

       
        
    }
    
    init(user: User, location: Location, comment: String, photos: [UIImage?]) {
        self.user = user
        self.location = location
        self.comment = comment
        self.photos = photos
    }
    
    func getFirebaseUser() {
        
    }
}


