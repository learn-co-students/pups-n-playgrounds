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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationProfileView = LocationProfileView(playground: playground!)
        view = locationProfileView
        
        FirebaseData.getPlaygroundsLocationCoordinates(for: (playground?.playgroundID)!) { (latitude: String, longitude: String) in
            
            print("Latitude = \(latitude) Longitude = \(longitude)")
        }
        
        FirebaseData.getReviewsFromFirebase(for: (playground?.playgroundID)!) { (dictionary) in
            print("REVIEWS = \(dictionary)")
        }
        navigationItem.title = "Location"
      
        locationProfileView.submitButton.addTarget(self, action: #selector(submitReviewAlert), for: .touchUpInside)        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func submitReviewAlert() {
        
        guard let name = locationProfileView.locationNameLabel.text else { return }
        guard let location = locationProfileView.location else { return }
        
        let alert = UIAlertController(title: "\(name)", message: "Type your review here!", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField { (reviewTextField) in
            reviewTextField.text = "" }
        
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: { (_) in
            let reviewTextField = alert.textFields![0]
            
            FirebaseData.addReview(comment: reviewTextField.text!, locationID: location.playgroundID)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension LocationProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let reviews = playground?.reviews {
            return reviews.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewsCell")!
        
        cell.textLabel?.text = "Test Location \(indexPath.row + 1)"
        cell.textLabel?.textColor = UIColor.themeWhite
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
}
