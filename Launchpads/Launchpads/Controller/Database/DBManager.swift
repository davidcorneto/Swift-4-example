//
//  DBManager.swift
//  Launchpads
//
//  Created by Alexey Gross on 27.11.17.
//  Copyright © 2017 gross. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class DBManager: NSObject {
    
    // MARK: - Initializers
    
    override init() {
        
        // Getting db file
//        let realm = try! Realm()
//        print("Database file path: \(String(describing: realm.configuration.fileURL!) )")
        
        super.init()
    }
    
    // MARK: - Public methods
    
    public func write(launchpads: NSArray, completion: @escaping (_ ready: (Bool)) -> Void) {
        
        DispatchQueue(label: "global_task").async {
            autoreleasepool {
                
                let realm = try! Realm()
                
                for launchpad_dict in launchpads {
                    if let launchpad: Launchpad = launchpad_dict as? Launchpad {
                        
                        // Without duplicates
                        if realm.object(ofType: Launchpad.self, forPrimaryKey: launchpad.objectId) != nil {
                            
                        } else {
                            try! realm.write {
                                realm.add(launchpad, update: false)
                            }
                        }
                    }
                }
                
                completion(true)
            }
        }
    }
    
    public func fetchLaunchpads(completion: @escaping (_ result: (Results<Launchpad>)) -> Void) {
        
        let realm = try! Realm()
        
        let launchpads = realm.objects(Launchpad.self)
        
        completion(launchpads)
    }
    
}
