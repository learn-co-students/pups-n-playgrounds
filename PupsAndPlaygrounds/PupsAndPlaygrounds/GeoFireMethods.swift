//
//  GeoFireMethods.swift
//  PupsAndPlaygrounds
//
//  Created by Felicity Johnson on 11/29/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import Firebase
import GeoFire


class GeoFireMethods {
  
  static func sendLocationToGeoFireWith(locations playground: Playground) {
    let geofireRef = FIRDatabase.database().reference().child("geoFireLocation")
    
    let geoFire = GeoFire(firebaseRef: geofireRef)
    let unqiueKey = playground.playgroundID
    
    geoFire?.setLocation(CLLocation(latitude: playground.latitude, longitude: playground.longitude), forKey: unqiueKey) { (error) in
      if (error != nil) {
        print("An error occured: \(error)")
      } else {
        print("Saved location successfully!")
      }
    }
  }
  
  static func retrieveUniqueKey(with completion: @escaping ([String]) -> Void) {
    let geofireRef = FIRDatabase.database().reference().child("geoFireLocation")
    
    let geoFire = GeoFire(firebaseRef: geofireRef)
    var uniqueIDs = [String]()
    
    geofireRef.observeSingleEvent(of: .value, with: { (snapshot) in
      guard let snapshotValue = snapshot.value as? [String: Any] else {return}
      
      for snap in snapshotValue {
        uniqueIDs.append(snap.key)
      }
      
      completion(uniqueIDs)
    })
    
  }
  
  
  static func getLocationFromFirebaseWith() {
    let geofireRef = FIRDatabase.database().reference().child("geoFireLocation")
    
    
    let geoFire = GeoFire(firebaseRef: geofireRef)
    print("INSIDE GET LOCATIONS FROM FIREBASE FUNC")
    
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
  
  
  static func getNearby(locations longitude: Double, latitude: Double, completion: @escaping ([CLLocationCoordinate2D]) -> Void) {
    
    let geofireRef = FIRDatabase.database().reference().child("geoFireLocation")
    
    var coordinatesArray = [CLLocationCoordinate2D]()
    
    
    let geoFire = GeoFire(firebaseRef: geofireRef)
    
    let center = CLLocation(latitude: latitude, longitude: longitude)
    // Query locations at [self.latitude, self.longitude] with a radius of 1 km
    let circleQuery = geoFire?.query(at: center, withRadius: 1.0)
    guard let unwrappedCircleQuery = circleQuery else { print("no query"); return }
    print("CIRCLE QUERY: \(unwrappedCircleQuery)")
    
    unwrappedCircleQuery.observe(.keyEntered, with: { (key, location) in
      guard let locationValue = location?.coordinate else { return }
      
      let latitude = locationValue.latitude
      let longitude = locationValue.longitude
      
      coordinatesArray.append(locationValue)
      print("COORDINATES ARRAY: \(coordinatesArray)")
      completion(coordinatesArray)
      
    })
    
    
    //        // Query location by region
    //        let span = MKCoordinateSpanMake(0.001, 0.001)
    //        let region = MKCoordinateRegionMake(center.coordinate, span)
    //        var regionQuery = geoFire?.query(with: region)
    //        print("REGION QUERY: \(regionQuery)")
  }
  
}
