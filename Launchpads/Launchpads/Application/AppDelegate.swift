//
//  AppDelegate.swift
//  Launchpads
//
//  Created by Alexey Gross on 26.11.17.
//  Copyright © 2017 gross. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController : UINavigationController!
    var launchpadListController : LaunchpadListController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        navigationController = UINavigationController()
        
        launchpadListController = LaunchpadListController(aWebServiceManager: WebServiceManager(), aDatabaseManager: DBManager())
        
        navigationController!.pushViewController(launchpadListController, animated: false)
        window?.rootViewController = navigationController!
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        
        return true
    }
}

