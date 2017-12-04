//
//  Location.swift
//  Launchpads
//
//  Created by Alexey Gross on 27.11.17.
//  Copyright © 2017 gross. All rights reserved.
//

import Foundation
import Mapper
import RealmSwift
import Realm

class Location: Object, Mappable {
    
    @objc dynamic var name: String = ""
    @objc dynamic var region: String = ""
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    
    required init(map: Mapper) throws {
        
        try name = map.from("name")
        try region = map.from("region")
        try latitude = map.from("latitude")
        try longitude = map.from("longitude")
        
        super.init()
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
}
