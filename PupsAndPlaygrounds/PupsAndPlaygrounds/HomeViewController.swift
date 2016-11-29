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


class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: Properties
    
    let mapView = MapView()
    let listView = ListView()
    var isMapView = true
    var locations = [Location]()
    var annotationArray = [MKAnnotation]()
    var longitude = Double()
    var latitude = Double()
    let locationManager = CLLocationManager()
    
    // MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        constrain()
    }
    
    private func configure() {
        title = "Map View"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Switch View"), style: .plain, target: self, action: #selector(switchView))
        
        listView.locationsTableView.delegate = self
        listView.locationsTableView.dataSource = self
        listView.locationsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
        listView.isHidden = true
        
        setupLocationManager()
        
        FirebaseData.getAllPlaygrounds { playgrounds in
            self.locations = playgrounds
            self.listView.locationsTableView.reloadData()
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
            
            
        }
        
    }
    
    
    private func setupLocationManager(){
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        if let unwrappedlatitude = locationManager.location?.coordinate.latitude, let unwrappedLongitude = locationManager.location?.coordinate.longitude{
            self.latitude = unwrappedlatitude
            self.longitude = unwrappedLongitude
            print("LAT: \(self.latitude)")
            print("Long: \(self.longitude)")
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
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
