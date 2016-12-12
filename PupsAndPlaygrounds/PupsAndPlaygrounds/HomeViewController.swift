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
import SnapKit

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
  lazy var filterView = FilterView()
  var filterViewBottomConstraint: Constraint?
  var showFilter = false
  lazy var mapView = MapView()
  lazy var listView = ListView()
  var isMapView = true
  var selectedAnnotation: CustomAnnotation?
  var locations = [Location]()
  
  var dogParks = [Dogrun]()
  var dogParkAnnotations = [CustomAnnotation]()
  var dogParksVisible = true
  
  var playgrounds = [Playground]()
  var playgroundAnnotations = [CustomAnnotation]()
  var playgroundsVisible = true
  
  let locationManager = CLLocationManager()
  let regionRadius: CLLocationDistance = 1000
  
  // MARK: Override Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configure()
    constrain()
    
    presentLocations {
      DispatchQueue.main.async {
        self.mapView.map.addAnnotations(self.dogParkAnnotations + self.playgroundAnnotations)
        self.listView.locationsTableView.reloadData()
      }
    }
  }
  
  private func configure() {
    navigationItem.title = "Map"
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filter))
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "List"), style: .plain, target: self, action: #selector(switchView))
    
    mapView.map.delegate = self
    mapView.map.showsUserLocation = true
    mapView.goToLocationButton.addTarget(self, action: #selector(goToLocation), for: .touchUpInside)
    
    listView.locationsTableView.delegate = self
    listView.locationsTableView.dataSource = self
    listView.locationsTableView.register(ListViewTableViewCell.self, forCellReuseIdentifier: "listCell")
    listView.locationsTableView.separatorStyle = .none
    listView.locationsTableView.rowHeight = 180
    listView.isHidden = true
    
    filterView.dogParksButton.addTarget(self, action: #selector(toggleDogParks), for: .touchUpInside)
    filterView.playgroundsButton.addTarget(self, action: #selector(togglePlaygrounds), for: .touchUpInside)
    
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
    
    // Center on user location if available
    if let userCoordinate = locationManager.location?.coordinate {
      centerMap(on: userCoordinate)
      
      // Central Park if unavailable
    } else {
      centerMap(on: CLLocationCoordinate2D(latitude: 40.785091, longitude: -73.968285))
    }
  }
  
  private func constrain() {
    view.addSubview(filterView)
    filterView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      filterViewBottomConstraint = $0.bottom.equalTo(view.snp.top).constraint
    }
    
    view.addSubview(mapView)
    mapView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.top.equalTo(filterView.snp.bottom)
    }
    
    view.addSubview(listView)
    listView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.top.equalTo(filterView.snp.bottom)
    }
    
    view.bringSubview(toFront: filterView)
  }
  
  private func presentLocations(completion: @escaping () -> Void) {
    WSRDataStore.shared.getLocations {
      if let dogParks = WSRDataStore.shared.dogRuns {
        self.dogParks = dogParks
      } else { print("error retrieving dogParks") }
      
      if let playgrounds = WSRDataStore.shared.playgrounds {
        self.playgrounds = playgrounds
      } else { print("error retrieving playgrounds") }
      
      self.dogParkAnnotations = self.dogParks.map { CustomAnnotation(withDogRun: $0) }
      self.playgroundAnnotations = self.playgrounds.map { CustomAnnotation(withPlayground: $0) }
      
      self.locations.append(contentsOf: self.dogParks as [Location] + self.playgrounds as [Location])
      
      completion()
    }
  }
  
  func filter() {
    showFilter = !showFilter
    
    view.layoutIfNeeded()
    if showFilter {
      UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { 
        self.filterViewBottomConstraint?.update(offset: self.filterView.frame.height)
        self.view.layoutIfNeeded()
      }, completion: nil)
    } else {
      UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
        self.filterViewBottomConstraint?.update(offset: 0)
        self.view.layoutIfNeeded()
      }, completion: nil)
    }
  }
  
  func switchView() {
    if isMapView {
      navigationItem.title = "List"
      navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "Map")
      listView.locationsTableView.reloadData()
      
    } else {
      navigationItem.title = "Map"
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
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? ListViewTableViewCell else {
      print("error unwrapping list table view cell")
      return UITableViewCell()
    }
    
    let location = locations[indexPath.row]
    
    cell.titleLabel.text = location.name
    cell.addressLabel.text = location.address
    
    if location is Dogrun {
      cell.locationType = .dogPark
    } else if locations[indexPath.row] is Playground {
      cell.locationType = .playground
    }
    
    if indexPath.row == locations.count - 1 {
      cell.visibleView.snp.makeConstraints {
        $0.bottom.equalToSuperview().offset(-10)
      }
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let dogRun = locations[indexPath.row] as? Dogrun {
      let dogRunVC = DogRunViewController()
      dogRunVC.dogrun = dogRun
      
      navigationController?.pushViewController(dogRunVC, animated: true)
    } else if let playground = locations[indexPath.row] as? Playground {
      let locationProfileVC = LocationProfileViewController()
      locationProfileVC.playgroundID = playground.playgroundID
      
      navigationController?.pushViewController(locationProfileVC, animated: true)
    } else { print("error downcasting location") }
  }
}

// MARK: - MKMapViewDelegate and Methods
extension HomeViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let annotation = annotation as? CustomAnnotation else { return nil }
    let identifier = "customAnnotationView"
    
    var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? CustomAnnotationView
    
    if view != nil {
      view?.annotation = annotation
    } else {
      view = CustomAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      view?.canShowCallout = false
    }
    
    switch annotation.location {
    case is Dogrun:
      view?.annotationType = .dogRun
      view?.image = #imageLiteral(resourceName: "DogParkColor")
    case is Playground:
      view?.annotationType = .playground
      view?.image = #imageLiteral(resourceName: "PlaygroundColor")
    default:
      print("annotation location type error")
    }
    
    return view
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    guard let annotation = view.annotation as? CustomAnnotation else { print("error unwrapping custom annotation"); return }
    selectedAnnotation = annotation
    
    guard let view = view as? CustomAnnotationView else { print("error unwrapping custom annotation view"); return }
    
    centerMap(on: annotation.coordinate)
    
    let callout = CustomCalloutView()
    callout.nameLabel.text = annotation.location.name
    callout.addressLabel.text = annotation.location.address
    callout.ratingLabel.text = "Rating: \(annotation.location.rating)"
    callout.center = CGPoint(x: view.bounds.width / 2 - 8, y: -callout.frame.height / 1.6)
    
    view.addSubview(callout)
    
    var tabBarHeight: CGFloat = 49
    if let height = tabBarController?.tabBar.frame.height {
      tabBarHeight = height
    }
    
    let offset = -(self.mapView.goToLocationButtonHeight + tabBarHeight)
    view.layoutIfNeeded()
    UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
      self.mapView.goToLocationButtonTopConstraint?.update(offset: offset)
      self.view.layoutIfNeeded()
    }, completion: nil)
  }
  
  func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
    guard let view = view as? CustomAnnotationView else { print("error unwrapping custom annotation view during deselect"); return }
    guard let annotationType = view.annotationType else { print("error unwrapping annotationType"); return }
    
    
    for subview in view.subviews {
      subview.removeFromSuperview()
    }
    
    view.layoutIfNeeded()
    UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
      self.mapView.goToLocationButtonTopConstraint?.update(offset: 0)
      self.view.layoutIfNeeded()
    }, completion: nil)
  }
  
  func goToLocation() {
    guard let playground = selectedAnnotation?.location as? Playground else { print("error unwrapping playground from selected location"); return }
    
    let locationProfileVC = LocationProfileViewController()
    locationProfileVC.playgroundID = playground.playgroundID
    
    navigationController?.pushViewController(locationProfileVC, animated: true)
  }
  
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

// MARK: Filter Buttons
extension HomeViewController {
  func toggleDogParks() {
    dogParksVisible = !dogParksVisible
    
    if dogParksVisible {
      filterView.dogParksButton.backgroundColor = UIColor.themeCoral
      mapView.map.addAnnotations(dogParkAnnotations)
      locations.append(contentsOf: dogParks as [Location])
    } else {
      filterView.dogParksButton.backgroundColor = UIColor.lightGray
      mapView.map.removeAnnotations(dogParkAnnotations)
      locations = playgroundsVisible ? playgrounds as [Location] : [Location]()
    }
    
    if !listView.isHidden { listView.locationsTableView.reloadData() }
  }
  
  func togglePlaygrounds() {
    playgroundsVisible = !playgroundsVisible
    
    if playgroundsVisible {
      filterView.playgroundsButton.backgroundColor = UIColor.themeCoral
      mapView.map.addAnnotations(playgroundAnnotations)
      locations.append(contentsOf: playgrounds as [Location])
    } else {
      
      filterView.playgroundsButton.backgroundColor = UIColor.lightGray
      mapView.map.removeAnnotations(playgroundAnnotations)
      locations = dogParksVisible ? dogParks as [Location] : [Location]()
    }
    
    if !listView.isHidden { listView.locationsTableView.reloadData() }
  }
}






