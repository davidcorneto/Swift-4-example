//
//  LaunchpadListController.swift
//  Launchpads
//
//  Created by Alexey Gross on 27.11.17.
//  Copyright © 2017 gross. All rights reserved.
//

import UIKit

class LaunchpadListController: UIViewController {
    
    // MARK: - Properties
    
    var launchpads: NSArray!
    var launchpadCellId: String!
    
    var launchpadListView: LaunchpadListView!
    
    private var webServiceManager: WebServiceManager!
    private var databaseManager: DBManager!
    
    // MARK: - Initialization
    
    public init(aWebServiceManager: WebServiceManager, aDatabaseManager: DBManager) {
        
        webServiceManager = aWebServiceManager
        databaseManager = aDatabaseManager
        
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        title = "Launchpads"
        
        launchpads = NSArray()
        
        launchpadCellId = "launchpadCellId"
        
        launchpadListView = LaunchpadListView()
        launchpadListView.tableView.register(LaunchpadCell.self, forCellReuseIdentifier: launchpadCellId)
    }
    
    // MARK: - Life cycle
    
    override func loadView() {
        view = launchpadListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLaunchpads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.dismissNotifications()
    }
    
    // MARK: - Private methods
    
    private func getLaunchpads() {
        
        self.databaseManager.fetchLaunchpads(completion: { (result) in
            
            if (result.count > 0) {
                
                let launchpads: NSMutableArray = NSMutableArray()
                for launchpad_dict in result {
                    launchpads.add(launchpad_dict)
                }
                
                DispatchQueue.main.async {
                    self.reloadTableView(launchPads: launchpads)
                }
                
            } else {
                
                let launchpadsTemp: NSMutableArray = NSMutableArray()
                
                let _ = self.webServiceManager.getLaunchpads().subscribe(onNext: { (event) in
                    launchpadsTemp.add(event)
                    
                }, onError: { (error) in
                    // TODO: Error handling here
                    // empty arrays, url connection errors, etc
                    
                }, onCompleted: {
                    
                    DispatchQueue.main.async {
                        self.reloadTableView(launchPads: launchpadsTemp)
                    }

                }, onDisposed: {
                    
                })
                
            }
        })
    }
    
    private func reloadTableView(launchPads: NSArray) {
        
        self.launchpads = launchPads
        
        if (launchpadListView.tableView.delegate == nil) {
            self.launchpadListView.tableView.delegate = self
        }
        
        if (launchpadListView.tableView.dataSource == nil) {
            self.launchpadListView.tableView.dataSource = self
        }
        
        self.launchpadListView.tableView.reloadData()
    }
    
    private func setupNotifications() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationEnteredForeground),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground,
                                               object: nil)
    }
    
    private func dismissNotifications() {
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIApplicationWillEnterForeground,
                                                  object: nil)
    }
    
    // MARK: - Notification handlers
    
    @objc func applicationEnteredForeground() {
        
        getLaunchpads()
    }
}

// MARK: - Table View delegate & data source

extension LaunchpadListController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return launchpads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: LaunchpadCell = tableView.dequeueReusableCell(withIdentifier: launchpadCellId, for: indexPath) as! LaunchpadCell
        let launchpad: Launchpad = launchpads.object(at: indexPath.row) as! Launchpad
        cell.update(launchpad: launchpad)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell: LaunchpadCell = tableView.cellForRow(at: indexPath) as! LaunchpadCell
        selectedCell.setSelected(false, animated: true)
        
        let launchpad: Launchpad = launchpads.object(at: indexPath.row) as! Launchpad
        let launchpadDetailController: LaunchpadDetailController = LaunchpadDetailController(aLaunchpad: launchpad)
        self.navigationController?.pushViewController(launchpadDetailController, animated: true)
    }
}
