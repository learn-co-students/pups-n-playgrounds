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
//  var isHandicap: String { get }
  
  var reviews: [Review?] { get }
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
  var reviews = [Review?]()
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
  
  init(ID: String, name: String, address: String, isHandicap: String, latitude: Double, longitude: Double, reviews: [Review?], photos: [UIImage?], isFlagged: String) {
    self.playgroundID = ID
    self.name = name
    self.address = address
    self.latitude = latitude
    self.longitude = longitude
    self.reviews = reviews
    self.photos = photos
    self.isFlagged = isFlagged
    self.isHandicap = isHandicap
  }
  
}

class Dogrun: Location {
  let dogRunID: String
  let name: String
  let latitude: Double
  let longitude: Double
  let address: String
  let isOffLeash: Bool
  let notes: String
  let isHandicap: Bool
  var isFlagged: String
  var rating: String
  lazy var reviews = [Review?]()
  lazy var photos = [UIImage?]()
  
  init(dogRunID: String, name: String, latitude: Double, longitude: Double, address: String, isOffLeash: Bool, notes: String, isHandicap: Bool, isFlagged: String, rating: String) {
    self.dogRunID = dogRunID
    self.name = name
    self.latitude = latitude
    self.longitude = longitude
    self.address = address
    self.isOffLeash = isOffLeash
    self.notes = notes
    self.isHandicap = isHandicap
    self.isFlagged = isFlagged
    self.rating = rating
  }
}


