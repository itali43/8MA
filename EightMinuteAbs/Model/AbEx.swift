//
//  AbEx.swift
//  EightMinuteAbs
//
//  Created by Elliott Williams on 9/30/18.
//  Copyright © 2018 AgrippaApps. All rights reserved.
//

import Foundation
import SwiftyJSON

struct AbEx {

        let name: String
        let details: String
        let id: Int
    
     static func getName(id: Int) -> String {
        let path = Bundle.main.path(forResource: "exercises", ofType: "json")!
        let jsonString = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        let json = JSON(parseJSON: jsonString!)
//        print("json: \(json)")
        if json[id]["name"].exists(){
//            print("exists")
            return json[id]["name"].stringValue

        } else {
            print("no exist")
            return "Russian Twist"

        }
    }
    
    static func getDetails(id: Int) -> String {
        let path = Bundle.main.path(forResource: "exercises", ofType: "json")!
        let jsonString = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        let json = JSON(parseJSON: jsonString!)
//        print("json: \(json)")
        if json[id]["details"].exists(){
//            print("exists")
            return json[id]["details"].stringValue
            
        } else {
            print("no exist")
            return "Russian Twist: \n Assume crunch position with feet and head held above floor.  Move exercise ball or interlocked hands back and forth above abs alternating sides hitting the floor."
            
        }
    }

    
        init(name: String, details: String, id: Int) {
            self.name = name
            self.details = details
            self.id = id
            
        }
        

}
