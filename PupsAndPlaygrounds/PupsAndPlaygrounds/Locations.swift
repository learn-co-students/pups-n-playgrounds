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

protocol Location {
    var name: String { get }
    var location: String { get }
    var latitude: Double { get }
    var longitude: Double { get }
    var isHandicap: Bool { get }
    var reviews: [Review] { get }
//    var photos: [UIImage] { get }
}

class Playground: Location {
    
    let playgroundID: String
    let name: String
    let location: String
    var isHandicap: Bool = false
    let latitude: Double
    let longitude: Double
    var profileImage: UIImage = #imageLiteral(resourceName: "playgroundTemplate")
    var reviews: [Review] = []
//    var photos: [UIImage] = []
    
    init(citydata: [String : Any]) {

        self.playgroundID = "PG+\(citydata["Playground_ID"] as! String)"
        self.name = citydata["Name"] as! String
        self.location = citydata["Location"] as! String
        self.latitude = citydata["lat"] as! Double
        self.longitude = citydata["lon"] as! Double

        
        if citydata["Accessible"] as! String == "Y" {
            self.isHandicap = true
        }
    }
    
    init(ID: String, name: String, location: String, handicap: String, latitude: Double, longitude: Double) {
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

class Dogrun: Location {
    
    let dogRunID: String
    let name: String
    let location: String
    let latitude: Double = 0.0
    let longitude: Double = 0.0
    let dogRunType: String
    let notes: String
    var isHandicap: Bool = false
    var reviews: [Review] = []
    //    var photos: [UIImage]
    
    init(citydata: [String : Any]) {
        self.dogRunID = "DR+\(citydata["Prop_ID"])"
        self.name = citydata["Name"] as! String
        self.location = citydata["Address"] as! String
        self.dogRunType = citydata["DogRuns_Type"] as! String
        self.notes = citydata["Notes"] as! String
        
        if citydata["Accessible"] as! String == "Y" {
            self.isHandicap = true
        }
    }
}
