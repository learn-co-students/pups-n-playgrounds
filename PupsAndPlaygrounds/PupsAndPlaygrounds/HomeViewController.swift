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

//class HomeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
//
//    // MARK: Properties
//
//    let mapView = MapView()
//    let listView = ListView()
//    var isMapView = true
//    var locations = [Location]()
//    var annotationArray = [MKAnnotation]()
//    var longitude = Double()
//    var latitude = Double()
//    var locationManager = CLLocationManager()
//
//    // MARK: Override Methods
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        configure()
//        constrain()
//        mapView.map.showsUserLocation = true
//
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        determineCurrentLocation()
//    }
//
//    private func configure() {
//        title = "Map View"
//
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Switch View"), style: .plain, target: self, action: #selector(switchView))
//
//        listView.locationsTableView.delegate = self
//        listView.locationsTableView.dataSource = self
//        listView.locationsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
//        listView.isHidden = true
//
//        determineCurrentLocation()
//
//        FirebaseData.getAllPlaygrounds { playgrounds in
//            self.locations = playgrounds
//            self.listView.locationsTableView.reloadData()
//        }
//
//
//        GeoFireMethods.getNearby(locations: longitude, latitude: latitude) { (coordinates) in
//            for coordinate in coordinates {
//                let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, 600, 600)
//                let annotation = MKPointAnnotation()
//                annotation.coordinate = coordinate
//                annotation.title = "TEST"
//                self.annotationArray.append(annotation)
//                self.mapView.map.setRegion(coordinateRegion, animated: true)
//
//            }
//            self.mapView.map.addAnnotations(self.annotationArray)
//
//            print("Test location annotations added.")
//        }
//
//    }
//
//
//    private func determineCurrentLocation(){
//
//        locationManager.delegate = self
//        locationManager.distanceFilter = 200.0
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()
//
//        if CLLocationManager.locationServicesEnabled() {
//            switch(CLLocationManager.authorizationStatus()) {
//            case .notDetermined, .restricted, .denied:
//                print("Sorry, we don't have access to your location right now.")
//
//                // if location is not available, locationManager(_:didFailWithError) called
//
//
//            case .authorizedAlways, .authorizedWhenInUse:
//                print("Location access granted.")
//                locationManager.startUpdatingHeading()
//                locationManager.startUpdatingLocation()
//            }
//        }
//
//        if let unwrappedlatitude = locationManager.location?.coordinate.latitude, let unwrappedLongitude = locationManager.location?.coordinate.longitude{
//            self.latitude = unwrappedlatitude
//            self.longitude = unwrappedLongitude
//            print("LAT: \(self.latitude)")
//            print("Long: \(self.longitude)")
//
//        }
//    }
//
//
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        let userLocation: CLLocation = locations[0] as CLLocation
//
//       //to stop listening for location updates, call stopUpdatingLocation()
//        manager.stopUpdatingLocation()
//        manager.delegate = nil
//        print("manager.stopUpdatingLocation called.")
//
//        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//
//        mapView.map.setRegion(region, animated: true)
//
//        //Annotation
//        let userAnnotation: MKPointAnnotation = MKPointAnnotation()
//        userAnnotation.coordinate = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
//        userAnnotation.title = "Current Location"
//        mapView.map.addAnnotation(userAnnotation)
//    }
//
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error)
//        print("Location data currently not available. Let's go to Central Park.")
//
//       // let defaultLocation = Playground(ID: "B139", name: "Heckscher Playground", location: "Grove To Linden Sts, Central To Wilson Aves", handicap: "N", latitude: 40.6952, longitude: -73.9184, reviews: [])
//
//        // Location model will need a coordinate property
//        //Playgrounds & dogs will need to adopt in order to display this location on map
//
//        //let center = CLLocationCoordinate2D(latitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude)
//
//       // let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//
//       // mapView.map.setRegion(region, animated: true)
//
//        //Annotation
//       // let defaultAnnotation: MKPointAnnotation = MKPointAnnotation()
//       // defaultAnnotation.coordinate = CLLocationCoordinate2D(latitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude)
//        //defaultAnnotation.title = "Central Park - Hecksher Playground"
//       // mapView.map.addAnnotation(defaultAnnotation)
//
//

class HomeViewController: UIViewController {
  
  // MARK: Properties
  lazy var mapView = MapView()
  lazy var listView = ListView()
  var isMapView = true
  var locations = [Location]()
  let locationManager = CLLocationManager()
  let regionRadius: CLLocationDistance = 1000
  
  // MARK: Override Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configure()
    constrain()
    pullData()
  }
  
  private func configure() {
    navigationItem.title = "Map View"
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "List"), style: .plain, target: self, action: #selector(switchView))
    
    mapView.map.showsUserLocation = true
    
    listView.locationsTableView.delegate = self
    listView.locationsTableView.dataSource = self
    listView.locationsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
    listView.isHidden = true
    
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
    
    if let userCoordinate = mapView.map.userLocation.location?.coordinate { centerMap(on: userCoordinate) } else { print("no"); return }
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
  
  private func pullData() {
    DispatchQueue.global(qos: .background).async {
      FirebaseData.getAllPlaygrounds { playgrounds in
        self.locations = playgrounds
        
        self.mapView.map.addAnnotations(playgrounds.map { playground -> MKPointAnnotation in
          let annotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: playground.latitude, longitude: playground.longitude))
          
          annotation.title = playground.name
          annotation.rating = playground.rating
          
          
          annotation.coordinate = CLLocationCoordinate2D(latitude: playground.latitude, longitude: playground.longitude)
          annotation.title = playground.name
          
          return annotation
        })
        
//        for (index, playground) in playgrounds.enumerated() {
//          guard index < 100 else { return }
//          
//          let annotation = MKPointAnnotation()
//          
//          annotation.coordinate = CLLocationCoordinate2D(latitude: playground.latitude, longitude: playground.longitude)
//          annotation.title = playground.name
//          
//          self.mapView.map.addAnnotation(annotation)
//        }
      }
    }
  }
  
  func switchView() {
    if isMapView {
      navigationItem.title = "List View"
      navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "Map")
    } else {
      navigationItem.title = "Map View"
      navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "List")
    }
    
    mapView.isHidden = !mapView.isHidden
    listView.isHidden = !listView.isHidden
    
    isMapView = !isMapView
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

// MARK: - MKMapViewDelegate and Methods
extension HomeViewController {
  func centerMap(on coordinate: CLLocationCoordinate2D) {
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2, regionRadius * 2)
    mapView.map.setRegion(coordinateRegion, animated: true)
  }
}

// MARK: CLLocationManagerDelegate
extension HomeViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let userLocation = locations.first else { print("error retrieving user's current location"); return }
    
    let latitude = userLocation.coordinate.latitude
    let longitude = userLocation.coordinate.longitude
  }
}





