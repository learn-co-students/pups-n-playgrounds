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
    var reviewsTableView: UITableView!
    var currentUser: User?
    var reviewsArray: [Review?] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let firebaseUserID = FIRAuth.auth()?.currentUser?.uid else { return }
        
        configure()
        
        if let playgroundReviewsIDs = playground?.reviewsID {
            
            for reviewID in playgroundReviewsIDs {
                guard let unwrappedReviewID = reviewID else { return }
                
                FirebaseData.getReview(with: unwrappedReviewID, completion: { (firebaseReview) in
                    
                    self.reviewsArray.append(firebaseReview)
                    
                    print("REVIEWS ARRAY NOW HAS \(self.reviewsArray.count) REVIEWS")
                    self.locationProfileView.reviewsTableView.reloadData()
                    
                })
                
            }
        }
        
        FirebaseData.getUser(with: firebaseUserID) { (currentFirebaseUser) in
            self.currentUser = currentFirebaseUser
        }
        print("THIS PLAYGROUND HAS \(playground?.reviewsID.count) REVIEWS")
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configure() {
        
        guard let unwrappedPlayground = playground else { return }
        self.locationProfileView = LocationProfileView(playground: unwrappedPlayground)
        
        reviewsTableView = locationProfileView.reviewsTableView
        locationProfileView.reviewsTableView.delegate = self
        locationProfileView.reviewsTableView.dataSource = self
        locationProfileView.reviewsTableView.register(ReviewsTableViewCell.self, forCellReuseIdentifier: "reviewCell")
        
        self.view.addSubview(locationProfileView)
        locationProfileView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.locationProfileView.submitReviewButton.addTarget(self, action: #selector(self.submitReviewAlert), for: .touchUpInside)
        
        
        
        navigationItem.title = "Location"
        navigationController?.isNavigationBarHidden = false
    }
    
    func submitReviewAlert() {
        
        guard let name = locationProfileView.locationNameLabel.text else { return }
        guard let location = locationProfileView.location else { return }
        
        let alert = UIAlertController(title: "\(name)", message: "Type your review here!", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField { (reviewTextField) in
            reviewTextField.text = "" }
        
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: { (_) in
            let reviewTextField = alert.textFields![0]
            
            FirebaseData.addReview(comment: reviewTextField.text!, locationID: location.playgroundID, rating: "\(self.locationProfileView.starReviews.value)")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func flagButtonTouched(sender: UIButton) {
        let cellContent = sender.superview!
        let cell = cellContent.superview! as! UITableViewCell
        let indexPath = locationProfileView.reviewsTableView.indexPath(for: cell)
        
        if let flaggedReview = reviewsArray[(indexPath?.row)!] {
            
            FirebaseData.flagReviewWith(unique: flaggedReview.reviewID, locationID: flaggedReview.locationID, comment: flaggedReview.comment, userID: flaggedReview.userID) {
                let alert = UIAlertController(title: "Success!", message: "You have flagged this comment for review", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                    FirebaseData.getVisibleReviewsForFeed { reviews in
                        self.reviewsArray = reviews
                        self.locationProfileView.reviewsTableView.reloadData()
                    }
                })
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}

extension LocationProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewsTableViewCell
        
        if let currentReview = reviewsArray[indexPath.row] {
            cell.review = currentReview
            //            cell.flagButton.addTarget(self, action: #selector(flagButtonTouched), for: .touchUpInside)
            
            
            if let currentUserID = currentUser?.userID {
                if currentReview.userID != currentUserID {
                    cell.deleteReviewButton.isHidden = true
                }
            }
        }
        return cell
    }
    
}
