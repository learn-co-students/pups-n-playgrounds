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
  }
  
  private func configure() {
    navigationItem.title = "Map View"
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "List"), style: .plain, target: self, action: #selector(switchView))
    
    mapView.map.delegate = self
    mapView.map.showsUserLocation = true
    
    let annotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 48.856614, longitude: 2.3522219000000177))
    annotation.title = "Test Title"
    annotation.rating = "10"
    annotation.distance = "0.95"
    
    mapView.map.addAnnotation(annotation)
    
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
extension HomeViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let annotation = annotation as? CustomAnnotation else { return nil }
    
    let identifier = "customAnnotationView"
    var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
    
    if view != nil {
      view?.annotation = annotation
    } else {
      view = CustomAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      view?.image = #imageLiteral(resourceName: "Location")
      view?.canShowCallout = false
    }
    
    return view
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    guard let annotation = view.annotation as? CustomAnnotation else { print("error unwrapping custom annotation"); return }
    centerMap(on: annotation.coordinate)
    
    let callout = CustomCalloutView()
    callout.titleLabel.text = annotation.title
    callout.ratingLabel.text = "Rating: \(annotation.rating ?? "")"
    callout.distanceLabel.text = "\(annotation.distance ?? "") mi"
    
    callout.center = CGPoint(x: view.bounds.size.width / 2, y: -callout.bounds.size.height * 0.52)
    view.addSubview(callout)
  }
  
  func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
    if view is CustomAnnotationView {
      for subview in view.subviews {
        subview.removeFromSuperview()
      }
    }
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





