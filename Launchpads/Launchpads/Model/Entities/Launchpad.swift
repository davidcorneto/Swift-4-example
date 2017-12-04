//
//  Launchpad.swift
//  Launchpads
//
//  Created by Alexey Gross on 27.11.17.
//  Copyright © 2017 gross. All rights reserved.
//

import Foundation
import Mapper
import RealmSwift
import Realm

class Launchpad: Object, Mappable {
    
    @objc dynamic var objectId: String = ""
    @objc dynamic var fullName: String = ""
    @objc dynamic var status: String = ""
    @objc dynamic var location: Location! = Location()
    @objc dynamic var vehiclesLaunched: String = ""
    @objc dynamic var details: String = ""
    
    required init(map: Mapper) throws {
        
        super.init()
        
        try objectId = map.from("id")
        try fullName = map.from("full_name")
        try status = map.from("status")
        try location = map.from("location", transformation: extractLocation)
        try vehiclesLaunched = map.from("vehicles_launched")
        try details = map.from("details")
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init() {
        super.init()
    }
    
    override class func primaryKey() -> String? {
        return "objectId"
    }
    
    // MARK: - Private methods
    
    private func extractLocation(object: Any?) throws -> Location {
        
        if let dict: NSDictionary = object as? NSDictionary {
            
            let location: Location = Location()
            location.latitude = dict.object(forKey: "latitude") as! Double
            location.longitude = dict.object(forKey: "longitude") as! Double
            location.name = dict.object(forKey: "name") as! String
            location.region = dict.object(forKey: "region") as! String
            
            return location
            
        } else {
            return Location()
        }
    }

}
