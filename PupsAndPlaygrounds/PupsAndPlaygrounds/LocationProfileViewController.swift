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
        print("PLAYGROUND TAPPED = \(playground?.name)")

        
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
        print("SUBMIT BUTTON STORE.PLAYGROUND = \(store.playgrounds.count)")
        guard let name = locationProfileView.locationNameLabel.text else { return }
        let alert = UIAlertController(title: "\(name)", message: "Type your review here!", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField { (reviewTextField) in
            reviewTextField.text = ""
        }
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: { (_) in
            let reviewTextField = alert.textFields![0]
            FirebaseData.addReview(comment: reviewTextField.text!, locationID: self.locationProfileView.location.playgroundID)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func populatePlaygroundArray(firebasePG: [Playground]) {
        print("LOCAL populatePlaygroundArray FUNCTION IS RUNNING")
        self.store.playgrounds = firebasePG
    }
    
}
