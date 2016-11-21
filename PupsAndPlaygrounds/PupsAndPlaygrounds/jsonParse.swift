//
//  jsonParse.swift
//  PupsAndPlaygrounds
//
//  Created by Robert Deans on 11/20/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

class JsonParse {
    /*
    class func parser() {
        
        if let path = Bundle.main.path(forResource: "playgroundnyc", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null {
                    print("jsonData: \(jsonObj)")
                } else {
                    print("Could not get json from file, make sure that file contains valid json.")
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Invaled filename/path")
        }
        
        
    }
    */
    
//    class func loadPlaygroundJson() -> NSDictionary? {
//        
//        guard let urlpath = Bundle.main.path(forResource: "playgroundsnyc", ofType: "json") else { return nil }
//        print("urlpath = \(urlpath)")
//        if let url = URL(string: urlpath) {
//            if let data = NSData(contentsOf: url) {
//                do {
//                    let dictionary = try JSONSerialization.jsonObject(with: (data as NSData) as Data, options: .allowFragments) as? NSDictionary
//                    
//                    return dictionary
//                } catch {
//                    print("Error: unable to parse")
//                }
//            }
//        }
//        return nil
//    }
    
    
    
    class func getPlaygrounds(completion: @escaping (_ data: [String : [String : Any]]) -> Void) {
        
        let filePath = Bundle.main.path(forResource: "playgroundsnyc", ofType:"json")
        let data = try! NSData(contentsOfFile:filePath!, options: NSData.ReadingOptions.uncached)
        
            do {
                let rawDictionary = try JSONSerialization.jsonObject(with: data as Data, options: []) as! [String : [String : Any]]
                
                completion(rawDictionary)
            } catch {
                print("JSON Serializaiton didnt work...")
        }
        
    }
    
    class func getDogruns(completion: @escaping (_ data: [String:[String: Any]]) -> Void) {
        
        let filePath = Bundle.main.path(forResource: "dogrunsnyc", ofType:"json")
        let data = try! NSData(contentsOfFile:filePath!, options: NSData.ReadingOptions.uncached)
        
        do {
            let rawDictionary = try JSONSerialization.jsonObject(with: data as Data, options: []) as! [String:[String: Any]]
            
            completion(rawDictionary)
        } catch {
            print("JSON Serializaiton didnt work...")
        }
        
    }
    
    
    

    
    
}
