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
    let userID: String
    let locationID: String
    let comment: String
    var rating: String?
    var photos: [UIImage?]
    let reviewID: String
    
    init(firebaseData: [String : Any]) {
        self.comment = firebaseData["comment"] as! String
        self.photos = []
        self.userID = firebaseData["userID"] as! String
        self.locationID = firebaseData["locationID"] as! String
        self.reviewID = firebaseData["reviewID"] as! String
    }
    
    init(userID: String, locationID: String, comment: String, photos: [UIImage?], reviewID: String) {
        self.userID = userID
        self.locationID = locationID
        self.comment = comment
        self.photos = photos
        self.reviewID = reviewID
    }
    

}


