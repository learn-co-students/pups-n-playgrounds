//
//  HomeViewController.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation


class HomeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // MARK: Properties
    
    let mapView = MapView()
    let listView = ListView()
    var isMapView = true
    var locations = [Location]()
    var annotationArray = [MKAnnotation]()
    var longitude = Double()
    var latitude = Double()
    var locationManager = CLLocationManager()
    
    // MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        constrain()
        mapView.map.showsUserLocation = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        determineCurrentLocation()
        
    }
    
    private func configure() {
        title = "Map View"
        print("CONFIGURING")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Switch View"), style: .plain, target: self, action: #selector(switchView))
        
        listView.locationsTableView.delegate = self
        listView.locationsTableView.dataSource = self
        listView.locationsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
        listView.isHidden = true
        
        determineCurrentLocation()
        
        FirebaseData.getAllPlaygrounds { playgrounds in
            self.locations = playgrounds
//            self.listView.locationsTableView.reloadData()
        }

        
        GeoFireMethods.getNearby(locations: longitude, latitude: latitude) { (coordinates) in
            for coordinate in coordinates {
                let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, 600, 600)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "TEST"
                self.annotationArray.append(annotation)
                self.mapView.map.setRegion(coordinateRegion, animated: true)
                
            }
            self.mapView.map.addAnnotations(self.annotationArray)
            
            print("Test location annotations added.")
        }
        
    }
    
    
    private func determineCurrentLocation(){
        
        locationManager.delegate = self
        locationManager.distanceFilter = 200.0
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("Sorry, we don't have access to your location right now.")
               
                // if location is not available, locationManager(_:didFailWithError) called
                
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Location access granted.")
                locationManager.startUpdatingHeading()
                locationManager.startUpdatingLocation()
            }
        }
        
        if let unwrappedlatitude = locationManager.location?.coordinate.latitude, let unwrappedLongitude = locationManager.location?.coordinate.longitude{
            self.latitude = unwrappedlatitude
            self.longitude = unwrappedLongitude
            print("LAT: \(self.latitude)")
            print("Long: \(self.longitude)")
            
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation: CLLocation = locations[0] as CLLocation
      
       //to stop listening for location updates, call stopUpdatingLocation()
        manager.stopUpdatingLocation()
        manager.delegate = nil
        print("manager.stopUpdatingLocation called.")
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.map.setRegion(region, animated: true)
       
        //Annotation 
        let userAnnotation: MKPointAnnotation = MKPointAnnotation()
        userAnnotation.coordinate = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        userAnnotation.title = "Current Location"
        mapView.map.addAnnotation(userAnnotation)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        print("Location data currently not available. Let's go to Central Park.")
        
       // let defaultLocation = Playground(ID: "B139", name: "Heckscher Playground", location: "Grove To Linden Sts, Central To Wilson Aves", handicap: "N", latitude: 40.6952, longitude: -73.9184, reviews: [])
        
        // Location model will need a coordinate property
        //Playgrounds & dogs will need to adopt in order to display this location on map
        
        //let center = CLLocationCoordinate2D(latitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude)
       
       // let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
       // mapView.map.setRegion(region, animated: true)
        
        //Annotation 
       // let defaultAnnotation: MKPointAnnotation = MKPointAnnotation()
       // defaultAnnotation.coordinate = CLLocationCoordinate2D(latitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude)
        //defaultAnnotation.title = "Central Park - Hecksher Playground"
       // mapView.map.addAnnotation(defaultAnnotation)
    
    }

    
    private func constrain() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(listView)
        listView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func switchView() {
        title = isMapView ? "List View" : "Map View"
        
        mapView.isHidden = !mapView.isHidden
        listView.isHidden = !listView.isHidden
        
        isMapView = !isMapView
        
        FirebaseData.getAllPlaygrounds { playgrounds in
            self.locations = playgrounds
            self.listView.locationsTableView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        cell.textLabel?.text = locations[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let locationProfileVC = LocationProfileViewController()
        guard let playground = locations[indexPath.row] as? Playground else { print("error downcasting to playground"); return }
        
        locationProfileVC.playground = playground
        navigationController?.pushViewController(locationProfileVC, animated: true)
    }
}
