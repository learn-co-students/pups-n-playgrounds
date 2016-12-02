//
//  FeedViewController.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/24/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SnapKit

class FeedViewController: UIViewController {
    
    // MARK: Properties
    let listView = ListView()
    var locations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ONCE")
        FirebaseData.getAllPlaygrounds { playgrounds in
            self.locations = playgrounds
            self.listView.locationsTableView.reloadData()
        }
        
        title = "Temporary Work Window!"
        
        listView.locationsTableView.delegate = self
        listView.locationsTableView.dataSource = self
        listView.locationsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
        
        view.addSubview(listView)
        listView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
}

// MARK: - UITableViewDelegate
extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
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
