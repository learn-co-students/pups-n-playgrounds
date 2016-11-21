//
//  FirebaseTestViewController.swift
//  PupsAndPlaygrounds
//
//  Created by Robert Deans on 11/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class FirebaseTestViewController: UIViewController {
    
    var reviewsView: FirebaseTestView!
    var firebaseData: FirebaseData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        
        reviewsView = FirebaseTestView()
        firebaseData = FirebaseData()
        
        reviewsView.submitButton.addTarget(self, action: #selector(submitToFirebaseTouched), for: .touchUpInside)
        
        view = reviewsView
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func submitToFirebaseTouched() {

        guard let review = reviewsView.reviewTextField.text else { print("error reviews field"); return }
        guard let rating = reviewsView.ratingTextField.text else { print("error ratings field"); return }

        
        firebaseData.addReview(with: review, rating: rating, locationID: "0000001 = Location ID")
        
    }
    
}
