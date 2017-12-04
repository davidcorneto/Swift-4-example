//
//  WebServiceManager.swift
//  Launchpads
//
//  Created by Alexey Gross on 27.11.17.
//  Copyright © 2017 gross. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class WebServiceManager: NSObject {
    
    let baseURL: String?
    let launchpadPath: String?
    
    // MARK: - Initializers
    
    override init() {
        
        // Setup URL's
        var urls: NSDictionary?
        if let path = Bundle.main.path(forResource: "urls", ofType: "plist") {
            urls = NSDictionary(contentsOfFile: path)
        }
        
        if let urlsDict = urls {
            baseURL = urlsDict["baseUrl"] as? String
            launchpadPath = urlsDict["launchpads"] as? String
        } else {
            baseURL = "https://api.spacexdata.com/"
            launchpadPath = "launchpads"
        }
        
        super.init()
    }
    
    // MARK: - Web calls
    
    // Using blocks
    func getLaunchpads(completion: @escaping (_ result: (NSMutableArray)) -> Void) {
        
        let launchpads: NSMutableArray = NSMutableArray()
        let launchpadsUrlString: String = "\(String(describing: baseURL!))\(String(describing: launchpadPath!))"
        
        Alamofire.request(launchpadsUrlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            if let JSON = response.result.value {
                
                let json_array: NSArray = JSON as! NSArray
                
                for launchpad_json in json_array {
                    
                    if let launchpad_dict: NSDictionary = launchpad_json as? NSDictionary {
                        let launchpad: Launchpad = Launchpad.from(launchpad_dict)!
                        
                        launchpads.add(launchpad)
                    }
                }
                
                completion((launchpads))
                
            } else {
                
                completion((launchpads))
            }
        }
    }
    
    // Using RxSwift
    func getLaunchpads() -> Observable<Launchpad> {
        
        return Observable.create { observer in
        
            let launchpads: NSMutableArray = NSMutableArray()
            let launchpadsUrlString: String = "\(String(describing: self.baseURL!))\(String(describing: self.launchpadPath!))"
            
            Alamofire.request(launchpadsUrlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    let json_array: NSArray = JSON as! NSArray
                    
                    for launchpad_json in json_array {
                        
                        if let launchpad_dict: NSDictionary = launchpad_json as? NSDictionary {
                            let launchpad: Launchpad = Launchpad.from(launchpad_dict)!
                            
                            launchpads.add(launchpad)
                            observer.on(.next(launchpad))
                        }
                    }
                    
                    observer.on(.completed)
                    
                } else {
                    observer.on(.error(ErrorConstants.WebServiceManagerError.notFound))
                }
            }
            return Disposables.create {
                
            }
        }
    }
    
}
