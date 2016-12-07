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

class DataStore {
    
    var playgrounds: [PlaygroundJSON] = []
    var dogRuns: [DogrunJSON] = []
    var user: User?
    
    static let sharedInstance = DataStore()
    
    // MARK: populates local arrays with data from JSON files
    
    func populatePlaygroundsFromJSON() {
        self.playgrounds = []
        JsonParse.getPlaygrounds { (rawDictionary) in
            if let dictionary2 = rawDictionary["playgrounds"]?["facility"] as? [[String : Any]]{
                for playgroundData in dictionary2 {
                    let playground = PlaygroundJSON(jsonData: playgroundData)
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
                    let dogrun = DogrunJSON(jsonData: dogrunData)
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
            FirebaseData.addPlaygroundsToFirebase(name: playground.name, address: playground.address, isHandicap: playground.isHandicap, latitude: playground.latitude, longitude: playground.longitude)
        }
    }
    
    func addDogRunsToFirebase() {
        for dogrun in dogRuns {
            FirebaseData.addDogrunsToFirebase(name: dogrun.name, address: dogrun.address, isHandicap: dogrun.isHandicap, dogRunType: dogrun.dogRunType, notes: dogrun.notes)
        }
    }
    
    func addDogrunsAndPlaygroundsToFirebase() {
        addDogRunsToFirebase()
        addPlaygroundsToFirebase()
    }
    
}


class PlaygroundJSON {

    let name: String
    let address: String
    let isHandicap: String
    let latitude: String
    let longitude: String

    
    init(jsonData: [String : Any]) {
        
        self.name = jsonData["Name"] as! String
        self.address = jsonData["Location"] as! String
        self.latitude = jsonData["lat"] as! String
        self.longitude = jsonData["lon"] as! String
        self.isHandicap = jsonData["Accessible"] as! String
        
    }
    
}

class DogrunJSON {
    
    let name: String
    let address: String
    let isHandicap: String
    let notes: String
    let dogRunType: String

    
    init(jsonData: [String : Any]) {
        
        self.name = jsonData["Name"] as! String
        self.address = jsonData["Address"] as! String
        self.isHandicap = jsonData["Accessible"] as! String
        self.notes = jsonData["Notes"] as! String
        self.dogRunType = jsonData["DogRuns_Type"] as! String
        
    }
    
}
