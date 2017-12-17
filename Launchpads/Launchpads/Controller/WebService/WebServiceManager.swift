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
    
    let _baseURL: String!
    let _launchpadPath: String!
    
    // MARK: - Initializers
    
    override init() {
        
        // Setup URL's
        var urls: NSDictionary?
        if let path = Bundle.main.path(forResource: "urls", ofType: "plist") {
            urls = NSDictionary(contentsOfFile: path)
        }
        
        if let urlsDict = urls {
            _baseURL = urlsDict["baseUrl"] as? String
            _launchpadPath = urlsDict["launchpads"] as? String
        } else {
            _baseURL = "https://api.spacexdata.com"
            _launchpadPath = "/v2/launchpads"
        }
        
        super.init()
    }
    
    // MARK: - Web calls
    
    // Using blocks
    func getLaunchpads(completion: @escaping (_ result: NSMutableArray) -> Void) {
        
        let launchpads: NSMutableArray = NSMutableArray()
        let launchpadsUrlString: String = _baseURL + _launchpadPath
        
        Alamofire.request(launchpadsUrlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            if let JSON = response.result.value {
                
                let json_array: NSArray = JSON as! NSArray
                
                for launchpad_json in json_array {
                    
                    if let launchpad_dict: NSDictionary = launchpad_json as? NSDictionary {
                        let launchpad: Launchpad = Launchpad.from(launchpad_dict)!
                        
                        launchpads.add(launchpad)
                    }
                }
                
                completion(launchpads)
                
            } else {
                
                completion(launchpads)
            }
        }
    }
    
    // Using RxSwift
    func getLaunchpads() -> Observable<Launchpad> {
        
        let launchpads: NSMutableArray = NSMutableArray()
        let launchpadsUrlString: String = _baseURL + _launchpadPath
        
        return Observable.create { observer in
            
            Alamofire.request(launchpadsUrlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    // Check for errors
                    if (response.error != nil) {
                        observer.onError(ErrorConstants.WebServiceManagerError.notFound)
                        return
                    }
                    
                    if let json_dict = JSON as? NSDictionary {
                        if json_dict["error"] != nil {
                            observer.onError(ErrorConstants.WebServiceManagerError.notFound)
                            return
                        }
                    }
                    
                    // Mapping
                    
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
