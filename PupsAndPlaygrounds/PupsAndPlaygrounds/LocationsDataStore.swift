//
//  LocationsDataStore.swift
//  PupsAndPlaygrounds
//
//  Created by Robert Deans on 11/20/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

// This is a useful class to edit local JSON data and push it to Firebase
// 1) Create a singleton (store)
// 2) In viewDidLoad() run : store.getDogrunsAndPlaygroundsFromJSON() to populate store's array
// 3) run : store.addDogrunsAndPlaygroundsToFirebase() to send store's array to Firebase

// *** THIS METHOD WILL OVER-WRITE ALL THE LOCATIONS DATA INCLUDING REVIEWS ***

// If you are only trying to edit a specific location or child, use a more precise function


import Foundation

class LocationsDataStore {
    
    var playgrounds: [Playground] = []
    var dogRuns: [Dogrun] = []
    
    static let sharedInstance = LocationsDataStore()
    
    // MARK: populates local arrays with data from JSON files
    
    func populatePlaygroundsFromJSON() {
        self.playgrounds = []
        JsonParse.getPlaygrounds { (rawDictionary) in
            if let dictionary2 = rawDictionary["playgrounds"]?["facility"] as? [[String : Any]]{
                for playgroundData in dictionary2 {
                    let playground = Playground(citydata: playgroundData)
                    self.playgrounds.append(playground)
                }
            }
        }
    }
    
    func populateDogrunsFromJSON() {
        self.dogRuns = []
        JsonParse.getDogruns { (rawDictionary) in
            if let dictionary2 = rawDictionary["dogruns"]?["facility"] as? [[String : Any]]{
                for dogrunData in dictionary2 {
                    let dogrun = Dogrun(citydata: dogrunData)
                    self.dogRuns.append(dogrun)
                }
            }
        }
    }
    
    func getDogrunsAndPlaygroundsFromJSON() {
        populateDogrunsFromJSON()
        populatePlaygroundsFromJSON()
    }
    
    
    // MARK: adds local arrays to Firebase
    
    func addPlaygroundsToFirebase() {
        for playground in playgrounds {
            FirebaseData.addPlaygroundsToFirebase(playgroundID: playground.playgroundID, name: playground.name, location: playground.address, isHandicap: playground.isHandicap, latitude: "\(playground.latitude)", longitude: "\(playground.longitude)")
        }
    }
    
    func addDogRunsToFirebase() {
        for dogrun in dogRuns {
            FirebaseData.addDogrunsToFirebase(dogRunID: dogrun.dogRunID, name: dogrun.name, location: dogrun.address, isHandicap: dogrun.isHandicap, dogRunType: dogrun.dogRunType, notes: dogrun.notes)
        }
    }
    
    func addDogrunsAndPlaygroundsToFirebase() {
        addDogRunsToFirebase()
        addPlaygroundsToFirebase()
    }
    
}

