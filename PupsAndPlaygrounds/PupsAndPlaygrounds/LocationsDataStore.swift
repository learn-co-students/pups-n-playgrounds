//
//  LocationsDataStore.swift
//  PupsAndPlaygrounds
//
//  Created by Robert Deans on 11/20/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

class DataStore {
    
    var playgrounds: [Playground] = []
    var dogRuns: [Dogrun] = []
    
    static let sharedInstance = DataStore()
    
    func getPlaygrounds() {
        self.playgrounds = []
        
        
        JsonParse.getPlaygrounds { (rawDictionary) in
            
            print("running json parse")
            
            if let dictionary2 = rawDictionary["playgrounds"]?["facility"] as? [[String : Any]]{
                print(dictionary2)
                
                for playgroundData in dictionary2 {
                    let playground = Playground(citydata: playgroundData)
                    self.playgrounds.append(playground)
                }
                
            }
            
        }
    }
    
    func getDogruns() {
        self.dogRuns = []
        
        JsonParse.getDogruns { (rawDictionary) in
            
            if let dictionary2 = rawDictionary["dogruns"]?["facility"] as? [[String : Any]]{
                print(dictionary2)
                
                for dogrunData in dictionary2 {
                    let dogrun = Dogrun(citydata: dogrunData)
                    self.dogRuns.append(dogrun)
                }
                
            }
        }
    }
    
    func getDogrunsAndPlaygrounds() {
        getDogruns()
        getPlaygrounds()
    }
    
}

