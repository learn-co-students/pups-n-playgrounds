//
//  User.swift
//  PupsAndPlaygrounds
//
//  Created by Robert Deans on 11/22/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import UIKit

class User {
    let uniqueID: String
    var firstName: String
    var lastName: String?
    var profilePhoto: UIImage?
    var reviews = [Review]()
    var photos = [UIImage?]()
    
    init(firebaseData: [String : Any]) {
        self.uniqueID = firebaseData[""] as! String
        self.firstName = firebaseData[""] as! String
        self.lastName = firebaseData[""] as! String
    }
    
    init(uniqueID: String, firstName: String, lastName: String?, reviews: [Review?]) {
        self.uniqueID = uniqueID
        self.firstName = firstName
        self.lastName = lastName
        self.reviews = reviews as! [Review]
    }
}
