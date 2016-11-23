//
//  MapkitTestViewController.swift
//  PupsAndPlaygrounds
//
//  Created by Robert Deans on 11/22/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
/*
class MapkitTestViewController: UIViewController, CLLocationManagerDelegate,NSURLConnectionDelegate,UITableViewDelegate {
    
    let locationManager = CLLocationManager()
    
    var latitude = 0.00;
    var Longitude = 0.00;
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location11 = locations.first {
            print("Found User's location: \(location11)")
            print("Latitude: \(location11.coordinate.latitude) Longitude: \(location11.coordinate.longitude)")
            latitude = location11.coordinate.latitude
            Longitude = location11.coordinate.longitude
            manager.startUpdatingLocation()
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
}
*/
