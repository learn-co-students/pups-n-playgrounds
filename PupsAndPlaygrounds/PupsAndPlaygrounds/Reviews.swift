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
    var user: User?
    var location: Location?
    let comment: String
    var photos = [UIImage?]()
    // let rating: Int

    init(firebaseData: [String : Any]) {
        self.comment = firebaseData["comment"] as! String
        
        let userID = firebaseData["userID"] as! String
        let locationID = firebaseData["locationID"] as! String

        let returnUser: User? = FirebaseData.returnUser(userID: userID)
        guard let unwrappedUser = returnUser else { return }
        self.user = returnUser
        
        let returnLocation: Location? = FirebaseData.returnLocation(locationID: locationID)
        guard let unwrappedLocation = returnLocation else { return }
        self.location = returnLocation
        
        self.photos = []
    }
    
    init(user: User, location: Location, comment: String, photos: [UIImage?]) {
        self.user = user
        self.location = location
        self.comment = comment
        self.photos = photos
    }
    
}


