//
//  TestFirebaseTableViewController.swift
//  PupsAndPlaygrounds
//
//  Created by Robert Deans on 11/25/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class TestFirebaseTableViewController: UITableViewController {
    
    let store = LocationsDataStore.sharedInstance
    var playgroundArray: [Playground] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        store.getDogrunsAndPlaygroundsFromJSON()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Playground")

    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let playgroundCount = store.playgrounds.count
        return playgroundCount
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Playground", for: indexPath)
        
        let playground = store.playgrounds[indexPath.row]
        
        cell.textLabel?.text = playground.name
        
        return cell
    }
    
    
    
    
    
    
}
