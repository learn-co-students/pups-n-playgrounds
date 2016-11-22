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

// *** submitButton will submit a review to Firebase, but can be used for any function! ***

class FirebaseTestViewController: UIViewController {
    
    var firebaseTestView: FirebaseTestView!
    var firebaseData: FirebaseData!

    
    let store = LocationsDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        
        store.getDogrunsAndPlaygrounds()
        
        firebaseTestView = FirebaseTestView()
        firebaseData = FirebaseData()
        
        
        firebaseTestView.submitButton.addTarget(self, action: #selector(addPlaygroundsToFirebaseTouched), for: .touchUpInside)
        
        view = firebaseTestView
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func submitToFirebaseTouched() {
        print("SUBMIT BUTTON TOUCHED")
        guard let review = firebaseTestView.reviewTextField.text else { print("error reviews field"); return }
        guard let rating = firebaseTestView.ratingTextField.text else { print("error ratings field"); return }
        
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
