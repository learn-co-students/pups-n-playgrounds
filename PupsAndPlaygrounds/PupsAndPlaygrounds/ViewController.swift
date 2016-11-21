//
//  ViewController.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 11/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var store = DataStore.sharedInstance
    
    var firebaseHolder: DataSomething!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        store.getDogrunsAndPlaygrounds()
        print("store's playgrounds = \(store.playgrounds)")
        print("store's dogruns = \(store.dogRuns)")
        
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

