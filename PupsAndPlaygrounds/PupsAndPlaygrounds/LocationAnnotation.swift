//
//  LocationAnnotation.swift
//  MapTest
//
//  Created by William Robinson on 12/1/16.
//  Copyright © 2016 William Robinson. All rights reserved.
//

import Foundation
import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
  
  // MARK: Properties
  let coordinate: CLLocationCoordinate2D
  var title: String?
  var rating: Int?
  var distance: Double?
  var image: UIImage?
  
  // MARK: Initialization
  init(coordinate: CLLocationCoordinate2D) { self.coordinate = coordinate }
}
