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
  
  var reviewDelegate: AddReviewProtocol?
  var reviewView: ReviewView!
  var location: Location? {
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
    reviewView = ReviewView(location: location)
    view.addSubview(reviewView)
    reviewView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    reviewView.submitReviewButton.addTarget(self, action: #selector(submitReview), for: .touchUpInside)
    reviewView.cancelButton.addTarget(self, action: #selector(closeReviewWindow), for: .touchUpInside)
  }
  
  func submitReview() {
    print("LOCATION ID \(location?.id)")
    let newReview = FIRClient.addReview(comment: reviewView.reviewTextView.text!, locationID: reviewView.location.id, rating: Int(reviewView.starReviews.value))
    FIRClient.calcAverageStarFor(location: reviewView.location.id)
    
    reviewDelegate?.addReview(with: newReview)
    
    closeReviewWindow()
  }
  
  func closeReviewWindow() {
    if let parent = parent as? LocationProfileViewController {
      parent.locationProfileView.reviewsTableView.reloadData()
      parent.navigationController?.navigationBar.isUserInteractionEnabled = true
      parent.tabBarController?.tabBar.isUserInteractionEnabled = true
    } else if let parent = parent as? DogRunViewController {
      parent.dogRunProfileView.dogReviewsTableView.reloadData()
      parent.navigationController?.navigationBar.isUserInteractionEnabled = true
      parent.tabBarController?.tabBar.isUserInteractionEnabled = true
    }
    
    // Remove from ContainerVC
    willMove(toParentViewController: nil)
    
    edgesConstraint = nil
    
    view.removeFromSuperview()
    removeFromParentViewController()
  }
}
