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

// *** submitButton is AMBIGUOUS!!! Check to see what the button will do in viewDidLoad ***

class FirebaseTestViewController: UIViewController {
    
    var firebaseTestView: FirebaseTestView!

    let store = LocationsDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        
        store.getDogrunsAndPlaygrounds()
        
        firebaseTestView = FirebaseTestView()
        
        
        firebaseTestView.submitButton.addTarget(self, action: #selector(submitReviewToFirebaseTouched), for: .touchUpInside)
        
        view = firebaseTestView
        
        FirebaseData.getPlaygroundsLocationCoordinates(with: store.playgrounds[0].playgroundID) { (longitude, latitude) in
            print(longitude, latitude)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func submitReviewToFirebaseTouched() {
        print("SUBMIT BUTTON TOUCHED")
        guard let review = firebaseTestView.reviewTextField.text else { print("error reviews field"); return }
        guard let rating = firebaseTestView.ratingTextField.text else { print("error ratings field"); return }
        
        FirebaseData.addReview(with: review, rating: rating, locationID: store.playgrounds[0].playgroundID)
        
    }
    
    func addPlaygroundsToFirebaseTouched() {
        var count = 0
        for playground in store.playgrounds {
            
            FirebaseData.addPlaygrounds(playgroundID: playground.playgroundID, name: playground.name, location: playground.location, isHandicap: playground.isHandicap, latitude: playground.latitude, longitude: playground.longitude)
            
            count += 1
        }
        print("There are \(count) playgrounds")
    }
    
    func addDogRunsToFirebase() {
        var count = 0
        for dogrun in store.dogRuns {
            
            FirebaseData.addDogruns(dogRunID: dogrun.dogRunID, name: dogrun.name, location: dogrun.location, isHandicap: dogrun.isHandicap, dogRunType: dogrun.dogRunType, notes: dogrun.notes)
            
            count += 1
        }
        print("There are \(count) dogruns")
    }
    
}
