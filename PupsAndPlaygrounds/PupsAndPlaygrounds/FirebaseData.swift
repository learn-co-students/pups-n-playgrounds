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
}
