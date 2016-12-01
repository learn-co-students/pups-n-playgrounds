//
//  Locations.swift
//
//
//  Created by Robert Deans on 11/19/16.
//
//

import Foundation
import UIKit
import MapKit

protocol Location: class {
    var name: String { get }
    var address: String { get }
    var isHandicap: Bool { get }
    var reviews: [Review] { get }
    // coordinate
    // var photos: [UIImage] { get }
}

class Playground: Location {
    
    let playgroundID: String
    let name: String
    let address: String
    var isHandicap: Bool = false
    let latitude: Double
    let longitude: Double
    var profileImage: UIImage = #imageLiteral(resourceName: "playgroundTemplate")
    var isFlagged = false
    
    var reviews: [Review] = []
    //    var photos: [UIImage] = []
    
    init(citydata: [String : Any]) {
        
        self.playgroundID = "\(citydata["Playground_ID"] as! String)"
        self.name = citydata["Name"] as! String
        self.address = citydata["Location"] as! String
        self.latitude = citydata["lat"] as! Double
        self.longitude = citydata["lon"] as! Double
        
        
        if citydata["Accessible"] as! String == "Y" {
            self.isHandicap = true
        }
    }
    
    init(ID: String, name: String, address: String, handicap: String, latitude: Double, longitude: Double, reviews: [Review]) {
        self.playgroundID = ID
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.reviews = reviews
        
        if handicap == "Yes" {
            self.isHandicap = true
        }
    }
    
}

class Dogrun: Location {
    
    let dogRunID: String
    let name: String
    let address: String
    let dogRunType: String
    let notes: String
    var isHandicap: Bool = false
    var reviews: [Review] = []
    var isFlagged = false

    //    var photos: [UIImage]
    
    init(citydata: [String : Any]) {
        self.dogRunID = "DR+\(citydata["Prop_ID"])"
        self.name = citydata["Name"] as! String
        self.address = citydata["Address"] as! String
        self.dogRunType = citydata["DogRuns_Type"] as! String
        self.notes = citydata["Notes"] as! String
        
        if citydata["Accessible"] as! String == "Y" {
            self.isHandicap = true
        }
    }
}
