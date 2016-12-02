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
    guard let annotation = annotation as? LocationAnnotation else { return nil }
    
    let identifier = "locationAnnotation"
    var annotationView: MKPinAnnotationView
    
    if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
      dequeuedView.annotation = annotation
      annotationView = dequeuedView
    } else {
      annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      annotationView.canShowCallout = true
      annotationView.calloutOffset = CGPoint(x: -8, y: -4)
      
      let rating = UILabel()
      rating.text = "••••••••••\n••••••••••\n••••••••••"
      rating.numberOfLines = 3
      
      let locationProfileButton = UIButton()
      locationProfileButton.setTitle("Checkout", for: .normal)
      locationProfileButton.setImage(#imageLiteral(resourceName: "Black Arrow"), for: .normal)
      
      let accessoryView = UIView()
      
      accessoryView.addSubview(rating)
      rating.snp.makeConstraints {
        $0.leading.equalToSuperview()
      }
      
      accessoryView.addSubview(locationProfileButton)
      locationProfileButton.snp.makeConstraints {
        $0.leading.equalTo(rating.snp.trailing)
        $0.trailing.equalToSuperview()
      }
    
      annotationView.detailCalloutAccessoryView = accessoryView
    }
    
    annotationView.pinTintColor = UIColor.white
    
    return annotationView
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





