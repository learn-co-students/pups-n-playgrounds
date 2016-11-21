//
//  FirebaseTestViewController.swift
//  PupsAndPlaygrounds
//
//  Created by Robert Deans on 11/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

class FirebaseTestViewController: UIViewController {
    
    var reviewsView: FirebaseTestView!
    var firebaseData: FirebaseData!
    
    let store = LocationsDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        
        reviewsView = FirebaseTestView()
        firebaseData = FirebaseData()
        store.getDogrunsAndPlaygrounds()
//        print("PLAYGROUNDS = \(store.playgrounds)")
        reviewsView.submitButton.addTarget(self, action: #selector(addDogRunsToFirebase), for: .touchUpInside)
        
        view = reviewsView
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func submitToFirebaseTouched() {
        print("SUBMIT BUTTON TOUCHED")
        guard let review = reviewsView.reviewTextField.text else { print("error reviews field"); return }
        guard let rating = reviewsView.ratingTextField.text else { print("error ratings field"); return }
        
        firebaseData.addReview(with: review, rating: rating, locationID: "0000001 = Location ID")
        
    }
    
    func addPlaygroundsToFirebaseTouched() {
        var count = 0
        for playground in store.playgrounds {
            
            firebaseData.addPlaygrounds(playgroundID: playground.playgroundID, name: playground.name, location: playground.location, isHandicap: playground.isHandicap, latitude: playground.latitude, longitude: playground.longitude)
            
            count += 1
        }
        print("There are \(count) playgrounds")
    }
    
    func addDogRunsToFirebase() {
        var count = 0
        for dogrun in store.dogRuns {
            
            firebaseData.addDogruns(dogRunID: dogrun.dogRunID, name: dogrun.name, location: dogrun.location, isHandicap: dogrun.isHandicap, dogRunType: dogrun.dogRunType, notes: dogrun.notes)
            
            count += 1
        }
        print("There are \(count) dogruns")
    }
    
}
