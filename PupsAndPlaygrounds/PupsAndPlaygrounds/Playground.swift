//
//  Playground.swift
//  PupsAndPlaygrounds
//
//  Created by Missy Allan on 11/23/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import MapKit

class Playground: NSObject, MKAnnotation {
    
    
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        
        
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    
    
    
    
}
