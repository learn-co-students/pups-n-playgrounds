//
//  LocationsDataStore.swift
//  PupsAndPlaygrounds
//
//  Created by Robert Deans on 11/20/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

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
            //FirebaseData.addPlaygroundsToFirebase(playgroundID: playground.playgroundID, name: playground.name, location: playground.location, isHandicap: playground.isHandicap, latitude: playground.latitude, longitude: playground.longitude)
        }
    }
    
    func addDogRunsToFirebase() {
        for dogrun in dogRuns {
            FirebaseData.addDogrunsToFirebase(dogRunID: dogrun.dogRunID, name: dogrun.name, location: dogrun.location, isHandicap: dogrun.isHandicap, dogRunType: dogrun.dogRunType, notes: dogrun.notes)
        }
    }
    
    func addDogrunsAndPlaygroundsToFirebase() {
        addDogRunsToFirebase()
        addPlaygroundsToFirebase()
    }
    
}

