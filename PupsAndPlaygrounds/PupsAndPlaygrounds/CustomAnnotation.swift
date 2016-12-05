//
//  CustomAnnotation.swift
//  MapTest
//
//  Created by William Robinson on 12/1/16.
//  Copyright © 2016 William Robinson. All rights reserved.
//

import Foundation
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
  
  // MARK: Properties
  let coordinate: CLLocationCoordinate2D
  var title: String?
  var rating: String?
  var distance: String?
  var image: UIImage?
  
  // MARK: Initialization
  init(coordinate: CLLocationCoordinate2D) { self.coordinate = coordinate }
}
