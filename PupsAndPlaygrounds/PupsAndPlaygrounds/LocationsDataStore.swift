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
    var dogRuns: [Dogruns] = []
    
    static let sharedInstance = DataStore()
    
    func getPlaygrounds() {
        self.playgrounds = []
        
        
        JsonParse.getPlaygroundsRAY { (rawDictionary) in
            
            print("running json parse")
            
            if let dictionary2 = rawDictionary["playgrounds"] as? [String:Any] {
                if let dictionary3 = dictionary2["facility"] {
                    print("dictionary3 = dictionary2[facility] = \(dictionary3)")
                    
                    
                    for playgroundData in dictionary2 {
                        let playground = Playground(citydata: playgroundData)
                        self.playgrounds.append(playground)
                    }
                    
                }
            }
            
            
            
            
        }
        
        print(playgrounds)
    }
    
    
    
    
}

