//
//  JSONSerializer.swift
//  PupsAndPlaygrounds
//
//  Created by William Robinson on 12/12/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import Firebase

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


final class JSONSerializer {
  static let ref = FIRDatabase.database().reference()
  
  static func getJSONPlaygrounds(completion: @escaping ([String : [String : Any]]) -> Void) {
    guard let filePath = Bundle.main.path(forResource: "playgroundsnyc", ofType: "json") else {
      print("error unwrapping json playgrounds file path")
      return
    }
    
    do {
      let data = try NSData(contentsOfFile: filePath, options: NSData.ReadingOptions.uncached)
      
      guard let rawDict = try JSONSerialization.jsonObject(with: data as Data, options: []) as? [String : [String : Any]] else {
        print("error typecasting json playground dictionary")
        return
      }
      
      completion(rawDict)
    } catch {
      print("error reading playground data from file in json serializer")
    }
  }
  
  static func populatePlaygroundsFromJSON() {
    getJSONPlaygrounds { rawDict in
      if let playgroundDict = rawDict["playgrounds"]?["facility"] as? [[String : Any]] {
        for playground in playgroundDict.map({ PlaygroundJSON(jsonData: $0) }) {
          addPlaygroundsToFirebase(name: playground.name, address: playground.address, isHandicap: playground.isHandicap, latitude: playground.latitude, longitude: playground.longitude)
        }
      }
    }
  }
  
  static func addPlaygroundsToFirebase(name: String, address: String, isHandicap: String, latitude: String, longitude: String) {
    let uniqueLocationKey = ref.childByAutoId().key
    
    ref.child("locations").child("playgrounds").updateChildValues(["PG\(uniqueLocationKey)" : ["name" : name, "address" : address, "isHandicap" : isHandicap, "latitude" : latitude, "longitude" : longitude, "isFlagged" : "false"]])
  }
  
  static func getJSONDogRuns(completion: @escaping ([String : [String : Any]]) -> Void) {
    guard let filePath = Bundle.main.path(forResource: "dogrunsnyc", ofType: "json") else {
      print("error unwrapping dog runs file path")
      return
    }
    
    do {
      let data = try NSData(contentsOfFile: filePath, options: NSData.ReadingOptions.uncached)
      
      guard let rawDict = try JSONSerialization.jsonObject(with: data as Data, options: []) as? [String : [String : Any]] else {
        print("error typecasting json dog run dictionary")
        return
      }
      
      completion(rawDict)
    } catch {
      print("error reading dog run data from file in json serializer")
    }
  }
  
  static func populateDogrunsFromJSON() {
    getJSONDogRuns { rawDict in
      if let dogRunDict = rawDict["dogruns"]?["facility"] as? [[String : Any]] {
        for dogRun in dogRunDict.map({ DogrunJSON(jsonData: $0) }) {
          addDogrunsToFirebase(name: dogRun.name, address: dogRun.address, isHandicap: dogRun.isHandicap, dogRunType: dogRun.dogRunType, notes: dogRun.notes)
        }
      }
    }
  }
  
  static func addDogrunsToFirebase(name: String, address: String, isHandicap: String, dogRunType: String, notes: String) {
    let uniqueLocationKey = ref.childByAutoId().key
    
    ref.child("locations").child("dogruns").updateChildValues( ["DR\(uniqueLocationKey)": ["name" : name, "location" : address, "isHandicap" : isHandicap, "dogRunType" : dogRunType, "notes" : notes, "isFlagged" : "false"]])
  }
}
