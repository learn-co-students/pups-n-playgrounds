//
//  HomeViewController.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
  
  // MARK: Properties
  let mapView = MapView()
  let listView = ListView()
  var isMapView = true
  var locations = [Location]()
  
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
    
    FirebaseData.getAllPlaygrounds { playgrounds in
      self.locations = playgrounds
      self.listView.locationsTableView.reloadData()
    }
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
