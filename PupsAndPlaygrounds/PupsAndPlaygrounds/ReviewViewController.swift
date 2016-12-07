//
//  ReviewViewController.swift
//  PupsAndPlaygrounds
//
//  Created by Felicity Johnson on 12/7/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SnapKit

class ReviewViewController: UIViewController {

    var reviewView: ReviewView!
    var location: Playground? {
        didSet {
            configReviewView()
        }
    }
    var centerConstraint: Constraint?
    var widthHeightConstraint: Constraint?
    
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
    }
    
    func submitReview() {
        print("LOCATION ID \(location?.playgroundID)")
        FirebaseData.addReview(comment: reviewView.reviewTextField.text!, locationID: reviewView.location.playgroundID, rating: String(reviewView.starReviews.value))
        guard let parent = parent as? LocationProfileViewController else { print("problem with parent VC as Location Prof VC"); return }
        parent.locationProfileView.reviewsTableView.reloadData()
        // Remove from ContainerVC
        willMove(toParentViewController: nil)
        
        centerConstraint = nil
        widthHeightConstraint = nil
        
        view.removeFromSuperview()
        
        removeFromParentViewController()
    }
    
    
}
