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
    var playgrounds = [Playground]()
    

    @IBOutlet var mapView: MKMapView!
    
  override func viewDidLoad() {
    super.viewDidLoad()
   
    let initialLocation = CLLocation(latitude: 40.730610, longitude: -73.935242)
    
    centerMapOnLocation(location: initialLocation)
    
    mapView.delegate = self
    
   // let playground = Playground(title: "Bath Beach Playground", locationName: "Bath Beach Playground",coordinate: CLLocationCoordinate2D(latitude: 40.6025, longitude: -74.0111111))
   
   // let onePlayground = Playground(ID: "B001", name: "American Playground", location: "Noble, Franklin, Milton Sts", handicap: "N", latitude: 40.7288, longitude: -73.9579, )
    
    
    // mapView.addAnnotation(onePlayground)
    
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)  
    }
    
}
    


