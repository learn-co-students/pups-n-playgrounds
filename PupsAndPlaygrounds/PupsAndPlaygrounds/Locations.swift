//
//  Locations.swift
//
//
//  Created by Robert Deans on 11/19/16.
//
//

import Foundation

protocol Location {
    var name: String { get }
    var location: String { get }
    var isHandicap: Bool { get }
//    var reviews: [Review] { get }
//    var photos: [UIImage] { get }
}

class Playground: Location {
    
    let playgroundID: String
    let name: String
    let location: String
    var isHandicap: Bool = false
    let latitude: String
    let longitude: String
    //    var reviews: [Review]
    //    var photos: [UIImage]
    
    init(citydata: [String : Any]) {
        self.playgroundID = citydata["Prop_ID"] as! String
        self.name = citydata["Name"] as! String
        self.location = citydata["Location"] as! String
        self.latitude = citydata["lat"] as! String
        self.longitude = citydata["lon"] as! String
        
        if citydata["Accessible"] as! String == "Y" {
            self.isHandicap = true
        }
    }
    
}

class Dogrun: Location {
    
    let dogRunID: String
    let name: String
    let location: String
    let dogRunType: String
    let notes: String
    var isHandicap: Bool = false
    //    var reviews: [Review]
    //    var photos: [UIImage]
    
    init(citydata: [String : Any]) {
        self.dogRunID = citydata["Prop_ID"] as! String
        self.name = citydata["Name"] as! String
        self.location = citydata["Address"] as! String
        self.dogRunType = citydata["DogRuns_Type"] as! String
        self.notes = citydata["Notes"] as! String
        
        if citydata["Accessible"] as! String == "Y" {
            self.isHandicap = true
        }
    }
}