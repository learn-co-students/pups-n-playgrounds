//
//  ViewController.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    let regionRadius: CLLocationDistance = 1000
    
    
    @IBOutlet weak var mapView: MKMapView!
    
  override func viewDidLoad() {
    super.viewDidLoad()
   
    let initialLocation = CLLocation(latitude: 40.730610, longitude: -73.935242)
    
    centerMapOnLocation(location: initialLocation)
    
    let playground = Playground(title: "Bath Beach Playground", locationName: "Bath Beach Playground",
                                coordinate: CLLocationCoordinate2D(latitude: 40.6025, longitude: -74.0111111))
    
    mapView.addAnnotation(playground)
    
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
  }

    
    
    
    


