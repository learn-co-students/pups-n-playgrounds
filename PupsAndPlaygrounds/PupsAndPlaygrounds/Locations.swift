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
  var id: String { get }
  var name: String { get }
  var address: String { get }
  var reviewIDs: [String] { get }
  var isFlagged: String { get }
  var photos: [UIImage]? { get }
  var rating: Int { get }
}

class Playground: Location {
  let id: String
  let name: String
  let latitude: Double
  let longitude: Double
  let address: String
  var profileImage: UIImage = #imageLiteral(resourceName: "playgroundTemplate")
  var reviewIDs = [String]()
  var photos: [UIImage]?
  var isFlagged = "false"
  var isHandicap: String
  var rating = 0
  
  init(id: String, name: String, address: String, isHandicap: String, latitude: Double, longitude: Double, reviewIDs: [String], rating: Int, photos: [UIImage]?, isFlagged: String) {
    self.id = id
    self.name = name
    self.address = address
    self.latitude = latitude
    self.longitude = longitude
    self.reviewIDs = reviewIDs
    self.photos = photos
    self.isFlagged = isFlagged
    self.isHandicap = isHandicap
    self.rating = rating
  }
}

class Dogrun: Location {
  let id: String
  let name: String
  let latitude: Double
  let longitude: Double
  let address: String
  let isOffLeash: Bool
  let notes: String
  let isHandicap: Bool
  var isFlagged: String
  var rating = 0
  var reviewIDs = [String]()
  var photos: [UIImage]?
  
  init(id: String, name: String, latitude: Double, longitude: Double, address: String, isOffLeash: Bool, notes: String, isHandicap: Bool, isFlagged: String, rating: Int) {
    self.id = id
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


