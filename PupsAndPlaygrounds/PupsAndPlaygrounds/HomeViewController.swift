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
    let centralParkCoordinate = CLLocationCoordinate2D(latitude: 40.785091, longitude: -73.968285)
    let wideRadius: CLLocationDistance = 800
    let midRadius: CLLocationDistance = 600
    let zoomRadius: CLLocationDistance = 400
    
    // MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        constrain()
        
        presentLocations {
            DispatchQueue.main.async {
                self.mapView.map.removeAnnotations(self.mapView.map.annotations)
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
        listView.isHidden = true
        
        filterView.dogParksButton.addTarget(self, action: #selector(toggleDogParks), for: .touchUpInside)
        filterView.playgroundsButton.addTarget(self, action: #selector(togglePlaygrounds), for: .touchUpInside)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Center on user location if available
        if let userCoordinate = locationManager.location?.coordinate {
            centerMap(on: userCoordinate, with: midRadius)
        } else {
            centerMap(on: centralParkCoordinate, with: wideRadius)
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
        DataStore.shared.getLocations {
            if let dogParks = DataStore.shared.dogRuns {
                self.dogParks = dogParks
            } else { print("error retrieving dogParks") }
            
            if let playgrounds = DataStore.shared.playgrounds {
                self.playgrounds = playgrounds
            } else { print("error retrieving playgrounds") }
            
            self.dogParkAnnotations = self.dogParks.map { CustomAnnotation(withDogRun: $0) }
            self.playgroundAnnotations = self.playgrounds.map { CustomAnnotation(withPlayground: $0) }
            
            self.locations = self.dogParks as [Location] + self.playgrounds as [Location]
            
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
            listView.isHidden = !listView.isHidden
            mapView.isHidden = !mapView.isHidden
        } else {
            navigationItem.title = "Map"
            navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "List")
            mapView.isHidden = !mapView.isHidden
            listView.isHidden = !listView.isHidden
        }
        
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dogRun = locations[indexPath.row] as? Dogrun {
            let dogRunVC = DogRunViewController()
            dogRunVC.dogrun = dogRun
            
            navigationController?.pushViewController(dogRunVC, animated: true)
        } else if let playground = locations[indexPath.row] as? Playground {
            let locationProfileVC = LocationProfileViewController()
            locationProfileVC.playgroundID = playground.id
            
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
            break
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? CustomAnnotation else {
            print("error unwrapping custom annotation")
            return
        }
        
        selectedAnnotation = annotation
        
        guard let view = view as? CustomAnnotationView,
            let annotationType = view.annotationType else {
                print("error unwrapping custom annotation view on selection")
                return
        }
        
        switch annotationType {
        case .dogRun:
            view.image = #imageLiteral(resourceName: "DogParkSelected")
        case .playground:
            view.image = #imageLiteral(resourceName: "PlaygroundSelected")
        }
        
        centerMap(on: annotation.coordinate, with: zoomRadius)
        
        let callout = CustomCalloutView()
        callout.nameLabel.text = annotation.location.name
        callout.addressLabel.text = annotation.location.address
        callout.starReview.value = Float(annotation.location.rating)
        callout.center = CGPoint(x: view.bounds.width / 2, y: -callout.frame.height / 1.6)
        
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
        guard let view = view as? CustomAnnotationView,
            let annotationType = view.annotationType else {
                print("error unwrapping custom annotation view on deselection")
                return
        }
        
        switch annotationType {
        case .dogRun:
            view.image = #imageLiteral(resourceName: "DogParkColor")
        case .playground:
            view.image = #imageLiteral(resourceName: "PlaygroundColor")
        }
        
        if let coordinate = view.annotation?.coordinate {
            centerMap(on: coordinate, with: midRadius)
        }
        
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
        
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
            self.mapView.goToLocationButtonTopConstraint?.update(offset: 0)
            
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func goToLocation() {
            
            if let dogRun = selectedAnnotation?.location as? Dogrun {
                let dogRunVC = DogRunViewController()
                dogRunVC.dogrunID = dogRun.id
                
                navigationController?.pushViewController(dogRunVC, animated: true)
            } else if let playground = selectedAnnotation?.location as? Playground {
                let locationProfileVC = LocationProfileViewController()
                locationProfileVC.playgroundID = playground.id
                
                navigationController?.pushViewController(locationProfileVC, animated: true)
            } else { print("error downcasting location") }
            
        
    }
    
    func centerMap(on coordinate: CLLocationCoordinate2D, with radius: CLLocationDistance) {
        mapView.map.setRegion(MKCoordinateRegionMakeWithDistance(coordinate, radius * 2, radius * 2), animated: true)
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






