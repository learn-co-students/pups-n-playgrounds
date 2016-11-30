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
    let user: User
    let location: Location
    let comment: String
    // let rating: Int
    let photos: [UIImage?]
    
    init(firebaseData: [String : Any]) {
        self.comment = firebaseData[""] as! String
        
        let userID = firebaseData["userID"] as! String
        FirebaseData.getUser(with: userID, completion: { (user) in
            self.user = user
        })
        
        let locationID = firebaseData["locationID"] as! String
        FirebaseData.getLocation(with: locationID) { (location) in
            self.location = location
        }
    }
    
    init(user: User, location: Location, comment: String, photos: [UIImage?]) {
        
    }
}

