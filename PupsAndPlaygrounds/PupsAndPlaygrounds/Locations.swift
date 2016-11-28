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

protocol Location: MKAnnotation {
    var name: String { get }
    var location: String { get }
    var isHandicap: Bool { get }
    var reviews: [Review] { get }
    var coordinate: CLLocationCoordinate2D {get}
//    var photos: [UIImage] { get }
}

class Playground: NSObject, Location {
    
    let playgroundID: String
    let name: String
    let location: String
    var isHandicap: Bool = false
    let latitude: Double
    let longitude: Double
    var coordinate = CLLocationCoordinate2D()
    var profileImage: UIImage = #imageLiteral(resourceName: "playgroundTemplate")
    
    var reviews: [Review] = []
//    var photos: [UIImage] = []
    
    init(citydata: [String : Any]) {

        self.playgroundID = "PG+\(citydata["Playground_ID"] as! String)"
        self.name = citydata["Name"] as! String
        self.location = citydata["Location"] as! String
        self.latitude = citydata["lat"] as! Double
        self.longitude = citydata["lon"] as! Double
        self.coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)

        
        if citydata["Accessible"] as! String == "Y" {
            self.isHandicap = true
        }
    }
    
    init(ID: String, name: String, location: String, handicap: String, latitude: Double, longitude: Double, coordinate: CLLocationCoordinate2D) {
        self.playgroundID = ID
        self.name = name
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        
        if handicap == "Yes" {
            self.isHandicap = true
        }
    }
    
}

class Dogrun: NSObject, Location {
    
    let dogRunID: String
    let name: String
    let location: String
    let dogRunType: String
    let notes: String
    var isHandicap: Bool = false
    var coordinate = CLLocationCoordinate2D()
    var reviews: [Review] = []
    //    var photos: [UIImage]
    
    init(citydata: [String : Any]) {
        self.dogRunID = "DR+\(citydata["Prop_ID"])"
        self.name = citydata["Name"] as! String
        self.location = citydata["Address"] as! String
        self.dogRunType = citydata["DogRuns_Type"] as! String
        self.notes = citydata["Notes"] as! String
        self.coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        
        
        if citydata["Accessible"] as! String == "Y" {
            self.isHandicap = true
        }
    }
}
