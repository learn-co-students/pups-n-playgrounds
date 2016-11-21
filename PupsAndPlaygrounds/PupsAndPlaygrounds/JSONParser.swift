//
//  jsonParse.swift
//  PupsAndPlaygrounds
//
//  Created by Robert Deans on 11/20/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

class JsonParse {
    
    
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
