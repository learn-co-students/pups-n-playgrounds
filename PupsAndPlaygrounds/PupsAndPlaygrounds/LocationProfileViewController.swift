//
//  LocationProfileViewController.swift
//  PupsAndPlaygrounds
//
//  Created by Robert Deans on 11/23/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class LocationProfileViewController: UIViewController {
    
    var playground: Playground?
    var locationProfileView: LocationProfileView!
    let store = LocationsDataStore.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        locationProfileView = LocationProfileView(playground: playground!)
        view = locationProfileView
        
        navigationItem.title = "Location"
        navigationController?.isNavigationBarHidden = true
        
        locationProfileView.submitButton.addTarget(self, action: #selector(submitReviewAlert), for: .touchUpInside)
    
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func submitReviewAlert() {

        guard let name = locationProfileView.locationNameLabel.text else { return }
        guard let location = locationProfileView.location else { return }
        print("LOCATION ID IS \(location.playgroundID)")
        
        let alert = UIAlertController(title: "\(name)", message: "Type your review here!", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField { (reviewTextField) in
            reviewTextField.text = "" }
        
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: { (_) in
            let reviewTextField = alert.textFields![0]
            
            FirebaseData.addReview(comment: reviewTextField.text!, locationID: location.playgroundID)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: gets data from Firebase... ideally...
    
    func populatePlaygroundArray(firebasePG: [Playground]) {
        print("LOCAL populatePlaygroundArray FUNCTION IS RUNNING")
        self.store.playgrounds = firebasePG
    }
    
    
    // MARK: functions to refersh Firebase data
    
    func addDogRunsAndPlaygroundsToFirebase() {
        addPlaygroundsToFirebase()
        addDogRunsToFirebase()
    }
    
    func addPlaygroundsToFirebase() {
        var count = 0
        for playground in store.playgrounds {
            
            FirebaseData.addPlaygroundsToFirebase(playgroundID: playground.playgroundID, name: playground.name, location: playground.location, isHandicap: playground.isHandicap, latitude: playground.latitude, longitude: playground.longitude)
            
            count += 1
        }
        print("There are \(count) playgrounds")
    }
    
    func addDogRunsToFirebase() {
        var count = 0
        for dogrun in store.dogRuns {
            
            FirebaseData.addDogrunsToFirebase(dogRunID: dogrun.dogRunID, name: dogrun.name, location: dogrun.location, isHandicap: dogrun.isHandicap, dogRunType: dogrun.dogRunType, notes: dogrun.notes)
            
            count += 1
        }
        print("There are \(count) dogruns")
    }
}
