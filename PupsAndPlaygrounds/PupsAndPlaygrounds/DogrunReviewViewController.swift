//
//  DogrunReviewViewController.swift
//  PupsAndPlaygrounds
//
//  Created by Missy Allan on 12/9/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

class DogrunReviewViewController: UIViewController {
    
    var dogrunReviewView: DogrunReviewView!
    var location: Dogrun? {
        didSet {
            configureDogrunReviewView()
            
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
    
    func configureDogrunReviewView() {
        guard let location = location else { print("error getting location."); return }
        DogrunReviewView = DogrunReviewView(dogrun: location)
        view.addSubview(DogrunReviewView)
        DogrunReviewView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        DogrunReviewView.dogCancelButton.addTarget(self, action: #selector(submitDogReview), for: .touchUpInside)
        
        DogrunReviewView.dogCancelButton.addTarget(self, action: #selector(closeDogReviewWindow), for: .touchUpInside)
    }
        
    
    func submitDogReview() {
        print("LOCATION ID: \(location?.dogRunID)")
        FirebaseData.addReview(comment: DogrunReviewView.dogReviewTextField.text!, locationID: DogrunReviewView.location.dogrunID, rating: String(DogrunReviewView.starReviews.value))
    
    }
    
    func closeDogReviewWindow() {
        guard let parent = parent as? DogRunViewController else { print("problem with parent VC as DogrunProfVC"); return }
        parent.dogRunProfileView.dogReviewsTableView.reloadData()
        //Remove from containerVC 
        willMove(toParentViewController: nil)
        
        edgesConstraint = nil
        
        view.removeFromSuperview()
        removeFromParentViewController()
        
        parent.navigationController?.navigationBar.isUserInteractionEnabled = true
        parent.tabBarController?.tabBar.isUserInteractionEnabled = true
    
       }
    }
    

    
    
    
    
    
    
    
    
