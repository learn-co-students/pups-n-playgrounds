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
  let location: Location
  let coordinate: CLLocationCoordinate2D
  
  // MARK: Initialization
  init(withPlayground playground: Playground) {
    location = playground
    coordinate = CLLocationCoordinate2D(latitude: playground.latitude, longitude: playground.longitude)
  }
  
  init(withDogRun dogRun: Dogrun) {
    location = dogRun
    coordinate = CLLocationCoordinate2D(latitude: dogRun.latitude, longitude: dogRun.longitude)
  }
}
