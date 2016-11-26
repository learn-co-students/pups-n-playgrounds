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
    let playgroundsArray: [Playground] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */



    

}
