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
    var isHandicap: String { get }
    
//    var reviews: [Review?] { get }
    //  var coordinates: CLLocationCoordinate2D {get set}
    //    var photos: [UIImage] { get }
    
    var isFlagged: String { get }
    var photos: [UIImage?] { get }
    var rating: String { get }
    
    
}

class Playground: Location {
    
    let playgroundID: String
    let name: String
    let address: String
    var isHandicap = "false"
    let latitude: Double
    let longitude: Double
    var profileImage: UIImage = #imageLiteral(resourceName: "playgroundTemplate")
    var reviewsID = [String?]()
    var photos = [UIImage?]()
    var isFlagged = "false"
    var rating = String(1)
    
    init(citydata: [String : Any]) {
        
        self.playgroundID = citydata["Playground_ID"] as! String
        self.name = citydata["Name"] as! String
        self.address = citydata["Location"] as! String
        self.latitude = citydata["lat"] as! Double
        self.longitude = citydata["lon"] as! Double
        self.isFlagged = citydata["isFlagged"] as! String
        self.isHandicap = citydata["isHandicap"] as! String
        
    }
    
    init(ID: String, name: String, address: String, isHandicap: String, latitude: Double, longitude: Double, reviewsID: [String?], photos: [UIImage?], isFlagged: String) {
        self.playgroundID = ID
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.reviewsID = reviewsID
        self.photos = photos
        self.isFlagged = isFlagged
        self.isHandicap = isHandicap
    }
    
}


class Dogrun /*: Location */ {
    
    //    let dogRunID: String
    //    let name: String
    //    let address: String
    //    let dogRunType: String
    //    let notes: String
    //    var isHandicap: Bool = false
    //    var reviews: [Review?] = []
    //    var isFlagged = false
    //
    //        var photos: [UIImage?]
    //
    //    init(citydata: [String : Any]) {
    //        self.dogRunID = "DR+\(citydata["Prop_ID"])"
    //        self.name = citydata["Name"] as! String
    //        self.address = citydata["Address"] as! String
    //        self.dogRunType = citydata["DogRuns_Type"] as! String
    //        self.notes = citydata["Notes"] as! String
    //
    //        if citydata["Accessible"] as! String == "Y" {
    //            self.isHandicap = true
    //        }
    //    }
}


