//
//  TestFirebaseTableViewController.swift
//  PupsAndPlaygrounds
//
//  Created by Robert Deans on 11/25/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class FirebaseTableViewController: UITableViewController {
  var playgroundArray: [Playground] = []
  let appDelegate = UIApplication.shared.delegate as? AppDelegate
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "List View"
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Switch View"), style: .plain, target: self, action: #selector(switchView))
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Playground")
    FirebaseData.getAllPlaygrounds { (playgroundsFromFirebase) in
      self.playgroundArray = playgroundsFromFirebase
      self.tableView.reloadData()
    }
  }
  
  func switchView() {
    
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let playgroundCount = playgroundArray.count
    return playgroundCount
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Playground", for: indexPath)
    
    let playground = playgroundArray[indexPath.row]
    
    cell.textLabel?.text = playground.name
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("DID SELECT ROW TAPPED")
    let locationProfileVC = LocationProfileViewController()
    locationProfileVC.playground = playgroundArray[indexPath.row]
    
    navigationController?.pushViewController(locationProfileVC, animated: true)
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
