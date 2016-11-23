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
        store.getDogrunsAndPlaygrounds()
        
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
        guard let name = locationProfileView.locationNameLabel.text else { return }
        let alert = UIAlertController(title: "\(name)", message: "Type your review here!", preferredStyle: UIAlertControllerStyle.alert)

        alert.addTextField { (reviewTextField) in
            reviewTextField.text = ""
        }
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: { (_) in
            let reviewTextField = alert.textFields![0]
            print("REVIEW = \(reviewTextField.text)")
        }))

        self.present(alert, animated: true, completion: nil)    }
    
}
