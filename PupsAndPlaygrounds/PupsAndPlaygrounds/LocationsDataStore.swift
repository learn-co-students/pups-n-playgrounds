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
    
}

