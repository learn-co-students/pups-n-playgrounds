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
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DID SELECT ROW TAPPED")
        let locationProfileVC = LocationProfileViewController()
        locationProfileVC.playground = store.playgrounds[indexPath.row]
        appDelegate?.window?.rootViewController = locationProfileVC
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("SEGUE BUTTON PRESSED")
//        if segue.identifier == "LocationsProfile" {
//            if let destination = segue.destination as? LocationProfileViewController, let indexPath = tableView.indexPathForSelectedRow {
//                
//                destination.playground = store.playgrounds[(indexPath as IndexPath).row]
//            }
//            
//        }
//    }
    
    
    
    
}
