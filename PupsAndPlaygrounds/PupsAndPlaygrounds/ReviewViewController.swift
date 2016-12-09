//
//  ReviewViewController.swift
//  PupsAndPlaygrounds
//
//  Created by Felicity Johnson on 12/7/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class ReviewViewController: UIViewController {

    var reviewView: ReviewView!
    var location: Playground? {
        didSet {
            configReviewView()
        }
    }
    var edgesConstraint: Constraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configReviewView() {
        guard let location = location else { print("problem getting location"); return }
        reviewView = ReviewView(playground: location)
        view.addSubview(reviewView)
        reviewView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        reviewView.submitReviewButton.addTarget(self, action: #selector(submitReview), for: .touchUpInside)
        reviewView.cancelButton.addTarget(self, action: #selector(closeReviewWindow), for: .touchUpInside)
    }
    
    func submitReview() {
        print("LOCATION ID \(location?.playgroundID)")
        FirebaseData.addReview(comment: reviewView.reviewTextField.text!, locationID: reviewView.location.playgroundID, rating: String(reviewView.starReviews.value))
        
        let ref = FIRDatabase.database().reference().child("reviews").child("visible")
        
        ref.observe(FIRDataEventType.value, with: { (snapshot) in
            
            var newReviews = [Review]()
            
            for item in snapshot.children {
                
                print("SNAPSHOT = \(snapshot)")
                
//                let reviewItem = Review(snapshot: item as! FIRDataSnapshot)
//                newReviews.append(reviewItem)
                
            }
//            LocationProfileViewController.reviewsArray = newReviews
//            LocationProfileViewController.reviewsRableView.reloadData()

            
        })
        
        closeReviewWindow()
    }
    
    func closeReviewWindow() {
        guard let parent = parent as? LocationProfileViewController else { print("problem with parent VC as Location Prof VC"); return }
        parent.locationProfileView.reviewsTableView.reloadData()
        // Remove from ContainerVC
        willMove(toParentViewController: nil)
        
        edgesConstraint = nil
        
        view.removeFromSuperview()
        removeFromParentViewController()
        
        parent.navigationController?.navigationBar.isUserInteractionEnabled = true
        parent.tabBarController?.tabBar.isUserInteractionEnabled = true
    }
}
