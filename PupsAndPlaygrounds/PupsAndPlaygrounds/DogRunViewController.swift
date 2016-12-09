//
//  DogRunViewController.swift
//  PupsAndPlaygrounds
//
//  Created by Missy Allan on 12/7/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SnapKit
import Firebase


class DogRunViewController: UIViewController, GMSMapViewDelegate {

    
    var dogrun: Dogrun?
    var dogRunProfileView: DogRunProfileView!
    var dogReviewsTableView: UITableView!
    var currentUser: User?
    var reviewsArray: [Review?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        guard let firebaseUserID = FIRAuth.auth()?.currentUser?.uid else {return}
        
        self.dogRunProfileView.submitReviewButton.addTarget(self, action: #selector(writeReview), for: .touchUpInside)
        
        if let dogrunReviwsID = dogrun?.reviewsID {
            
            for reviewID in dogrunReviwsID {
                guard let unwrappedReviewID = reviewID else { return }
                
                FirebaseData.getReview(with: unwrappedReviewID, completion: { (firebaseReview) in
                    
                    self.reviewsArray.apped(firebaseReview)
                    print("REVIEWS ARRAY NOW HAS \(self.reviewsArray.count) REVIEWS.")
                    self.dogRunProfileView.reviewsTableView.reloadData()
                
                })
            }

    }
        
        FirebaseData.getUser(with: firebaseUserID) { (currentFirebaseUser) in
            self.currentUser = currentFirebaseUser
        }
    
        print("THIS DOGRUN HAS \(dogrun?.reviewsID.count) REVIEWS")
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: Setup ReviewVC Child 
    
    func writeReview() {
        navigationController?.navigationBar.isUserInteractionEnabled = false
        tabBarController?.tabBar.isUserInteractionEnabled = false
 
        print("CLICKED REVIEW BUTTON")
        let childVC = DogrunReviewViewController
        childVC.location = dogrun
        
        addChildViewController(childVC)
        
        view.addSubview(childVC.view)
        childVC.view.snp.makeConstraints {
            childVC.edgesConstraint = $0.edges.equalToSuperview().constraint
        }
        childVC.didMove(toParentViewController: self)
        
        view.layoutIfNeeded()
    }
    
    
    func configure() {
        
        guard let unwrappedDogRun = dogrun else {return}
        self.dogRunProfileView = DogRunProfileView(dogrun: unwrappedDogRun)
        
         reviewsTableView = dogRunProfileView.reviewsTableView
         dogRunProfileView.reviewsTableView.delegate = self
         dogRunProfileView.reviewsTableView.dataSource = self
         dogRunProfileView.reviewsTableView.register(ReviewsTableViewCell.self, forCellReuseIdentifier: "reviewCell")
        
        self.view.addSubview(dogRunProfileView)
        dogRunProfileView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
  
    //configure() function finished
    }
    
    func flagButtonTouched(sender: UIButton) {
        
      let cellContent = sender.superview!
      let cell = cellContent.superview! as! UITableViewCell
      let indexPath = dogRunProfileView.reviewsTableView.indexPath(for: cell)
        
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

extension DogRunViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         return  reviewsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewsTableViewCell
        
        if let currentReview = reviewsArray[indexPath.row] {
            cell.review = currentReview
            
            if let currentUserID = currentUser?.userID {
                if currentReview.userID != currentUserID {
                    cell.deleteReviewButton.isHidden = true
                }
            }
        }
        return cell
    }
}
        
        
        
        
   
    
        
            
            
            
            
            
            
            
            

    
    
    
    

