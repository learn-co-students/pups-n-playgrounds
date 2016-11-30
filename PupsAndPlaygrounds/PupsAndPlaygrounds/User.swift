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
    var lastName: String
    var profilePhoto: UIImage?
    var reviews = [Review]()
    var photos = [UIImage?]()
    
    init(citydata: [String : Any]) {
        self.uniqueID = citydata[""] as! String
        self.firstName = citydata[""] as! String
        self.lastName = citydata[""] as! String
    }
}
