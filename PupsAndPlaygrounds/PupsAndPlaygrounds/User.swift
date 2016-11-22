//
//  User.swift
//  PupsAndPlaygrounds
//
//  Created by Robert Deans on 11/22/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

class User {
    
    var userName: String
    let uniqueID: String
    //    var profilePhoto: UIImage
    //    var reviews: [Reviews] = []
    //    var photoGallery
    
    init(profileData userName: String, uniqueID: String) {
        self.userName = userName
        self.uniqueID = uniqueID
    }
    
    
}
