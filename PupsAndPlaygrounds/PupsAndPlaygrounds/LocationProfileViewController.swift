//
//  LocationProfileViewController.swift
//  PupsAndPlaygrounds
//
//  Created by Robert Deans on 11/23/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class LocationProfileViewController: UIViewController {
    
    var locationProfileView: LocationProfileView!
    let store = LocationsDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("STORE'S STARTING PLAYGROUND.COUNT = \(store.playgrounds.count)")
        
        let firebasePlaygrounds = FirebaseData.getAllPlaygrounds

        print("PLAYGROUND.COUNT AFTER INITIALIZING = \(store.playgrounds.count)")
        
        populatePlaygroundArray(firebasePG: firebasePlaygrounds())
        
        navigationItem.title = "Location"
        navigationController?.isNavigationBarHidden = false
        
        locationProfileView = LocationProfileView()
        view = locationProfileView
        
        
        locationProfileView.submitButton.addTarget(self, action: #selector(submitReviewAlert), for: .touchUpInside)
        


        
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func submitReviewAlert() {
        print("SUBMIT BUTTON STORE.PLAYGROUND = \(store.playgrounds.count)")
        guard let name = locationProfileView.locationNameLabel.text else { return }
        let alert = UIAlertController(title: "\(name)", message: "Type your review here!", preferredStyle: UIAlertControllerStyle.alert)

        alert.addTextField { (reviewTextField) in
            reviewTextField.text = ""
        }
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: { (_) in
            let reviewTextField = alert.textFields![0]
            print("REVIEW = \(reviewTextField.text)")
            FirebaseData.addReview(comment: reviewTextField.text!, locationID: self.locationProfileView.location.playgroundID)
        }))

        self.present(alert, animated: true, completion: nil)    }
 
    func populatePlaygroundArray(firebasePG: [Playground]) {
        print("LOCAL populatePlaygroundArray FUNCTION IS RUNNING")
        store.playgrounds = firebasePG
    }
    
}
