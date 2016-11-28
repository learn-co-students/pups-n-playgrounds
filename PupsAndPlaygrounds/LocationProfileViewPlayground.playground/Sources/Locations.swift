//
//  Locations.swift
//
//
//  Created by Robert Deans on 11/19/16.
//
//

import Foundation
import UIKit


class Playground {
    
    let playgroundID: String
    let name: String
    let location: String
    var isHandicap: Bool = false
    let latitude: String
    let longitude: String
    var profileImage: UIImage = #imageLiteral(resourceName: "playgroundTemplate")
    
    init(ID: String, name: String, location: String, handicap: String, latitude: String, longitude: String) {
        self.playgroundID = ID
        self.name = name
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        
        if handicap == "Yes" {
            self.isHandicap = true
        }
    }
    
}
