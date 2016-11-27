//
//  ViewController.swift
//  GeoFireTest
//
//  Created by Felicity Johnson on 11/27/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit
import GeoFire
import Firebase
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    
    let locationManager = CLLocationManager()
    var latitude = Double()
    var longitude = Double()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func sendLocationToGeoFire() {
        
        let geofireRef = FIRDatabase.database().reference().child("geoFireLocation")
        let geoFire = GeoFire(firebaseRef: geofireRef)
        let unqiueKey = FIRDatabase.database().reference().childByAutoId().key
        
        geoFire?.setLocation(CLLocation(latitude: latitude, longitude: longitude), forKey: unqiueKey) { (error) in
            if (error != nil) {
                print("An error occured: \(error)")
            } else {
                print("Saved location successfully!")
            }
        }
    }
    
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        if let unwrappedlatitude = locationManager.location?.coordinate.latitude, let unwrappedLongitude = locationManager.location?.coordinate.longitude{
            self.latitude = unwrappedlatitude
            self.longitude = unwrappedLongitude
            
        }
    }
    
    
    func retrieveUniqueKey(with completion: @escaping ([String]) -> Void) {
        let geofireRef = FIRDatabase.database().reference().child("geoFireLocation")
        var uniqueIDs = [String]()
        
        geofireRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshotValue = snapshot.value as? [String: Any] else {return}
            
            for snap in snapshotValue {
                uniqueIDs.append(snap.key)
            }
            
            completion(uniqueIDs)
        })
        
    }
    
    
    func getLocationFromFirebaseWith() {
        
        let geofireRef = FIRDatabase.database().reference().child("geoFireLocation")
        let geoFire = GeoFire(firebaseRef: geofireRef)
        
        retrieveUniqueKey { (uniqueIDs) in
            for id in uniqueIDs {
                
                geoFire?.getLocationForKey(id, withCallback: { (location, error) in
                    if (error != nil) {
                        print("An error occurred getting the location for \"\(id)")
                    } else if (location != nil) {
                        print("Location for \(id)\" is [\(location?.coordinate.latitude), \(location?.coordinate.longitude)]")
                    } else {
                        print("GeoFire does not contain a location for \"\(id)\"")
                    }
                })

                
            }
        }
    }
    
    
    func getNearbyLocations() {
        
        let center = CLLocation(latitude: 37.7832889, longitude: -122.4056973)
        // Query locations at [37.7832889, -122.4056973] with a radius of 600 meters
        var circleQuery = geoFire.queryAtLocation(center, withRadius: 0.6)
        
        // Query location by region
        let span = MKCoordinateSpanMake(0.001, 0.001)
        let region = MKCoordinateRegionMake(center.coordinate, span)
        var regionQuery = geoFire.queryWithRegion(region)
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    
    @IBAction func sendLocationButton(_ sender: Any) {
        sendLocationToGeoFire()
    }
    
    
    @IBAction func getLocations(_ sender: Any) {
        getLocationFromFirebaseWith()
        
    }
    
    @IBAction func getLocationsNearby(_ sender: Any) {
    }

    
    
    
    
}



