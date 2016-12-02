//
//  LocationProfileViewController.swift
//  PupsAndPlaygrounds
//
//  Created by Robert Deans on 11/23/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase


class LocationProfileViewController: UIViewController {
    var playground: Playground?
    var locationProfileView: LocationProfileView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PLAYGROUND = \(playground?.playgroundID) ")

        FirebaseData.getLocation(with: playground!.playgroundID) { (firebaseLocation) in
            print("FIREBASE LOCATION \(firebaseLocation)")
            print("FIREBASE NAME \(firebaseLocation?.name)")
            print("PLAYGROUND COUNT = \(firebaseLocation?.reviews.count) ")
            self.playground = firebaseLocation as! Playground?
            
            self.locationProfileView = LocationProfileView(playground: self.playground!)
            self.locationProfileView.reviewsTableView.delegate = self
            self.locationProfileView.reviewsTableView.dataSource = self
            self.locationProfileView.reviewsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "reviewsCell")
            
           self.view.addSubview(self.locationProfileView)
            self.locationProfileView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            self.locationProfileView.submitReviewButton.addTarget(self, action: #selector(self.submitReviewAlert), for: .touchUpInside)

            
        }
        
        title = "Location"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("VIEW IS WILL APPEARING")
        
        let ref = FIRDatabase.database().reference().root
        
        ref.observe(FIRDataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String:Any] ?? [:]
            
            print("SNAPSHOT = \(postDict)")
//            var newReview: Review!
            self.locationProfileView.reviewsTableView.reloadData()
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func submitReviewAlert() {
        
        guard let location = locationProfileView.location else { return }
        let name = location.name
        
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
        
        if let review = playground?.reviews[indexPath.row] {
            cell.textLabel?.text = review.comment
            cell.textLabel?.textColor = UIColor.blue
            cell.textLabel?.font = UIFont.themeTinyRegular
            cell.textLabel?.numberOfLines = 3
            cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            
        }
        return cell
    }
}
