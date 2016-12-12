//
//  Review.swift
//  PupsAndPlaygrounds
//
//  Created by Robert Deans on 11/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import UIKit

class Review {
  let reviewID: String
  let userID: String
  let locationID: String
  let rating: Int
  let comment: String
  
  init(reviewID: String, userID: String, locationID: String, rating: Int, comment: String) {
    self.reviewID = reviewID
    self.userID = userID
    self.locationID = locationID
    self.rating = rating
    self.comment = comment
  }
}


