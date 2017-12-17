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
    
    var _launchpads: NSArray!
    var _launchpadCellId: String!
    
    var _launchpadListView = LaunchpadListView(frame: .zero)
    
    private var _webServiceManager: WebServiceManager!
    private var _databaseManager: DBManager!
    
    // MARK: - Initialization
    
    public init(aWebServiceManager: WebServiceManager, aDatabaseManager: DBManager) {
        
        _webServiceManager = aWebServiceManager
        _databaseManager = aDatabaseManager
        
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        title = "Launchpads"
        
        _launchpads = NSArray()
        
        _launchpadCellId = "launchpadCellId"
        
        _launchpadListView.tableView.register(LaunchpadCell.self, forCellReuseIdentifier: _launchpadCellId)
        _launchpadListView.tableView.delegate = self
        _launchpadListView.tableView.dataSource = self
    }
    
    // MARK: - Life cycle
    
    override func loadView() {
        super.loadView()
        view = _launchpadListView
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
        
        dismissNotifications()
    }
    
    // MARK: - Private methods
    
    private func getLaunchpads() {
        
        _databaseManager.fetchLaunchpads(completion: { [weak self] (result) in
            
            if (result.count > 0) {
                
                let launchpads: NSMutableArray = NSMutableArray()
                for launchpad_dict in result {
                    launchpads.add(launchpad_dict)
                }
                
                DispatchQueue.main.async {
                    self?.reloadTableView(launchpads: launchpads)
                }
                
            } else {
                
                let launchpadsTemp: NSMutableArray = NSMutableArray()
                
                let _ = self?._webServiceManager.getLaunchpads().subscribe(onNext: { (event) in
                    launchpadsTemp.add(event)
                    
                }, onError: { (error) in
                    
                    self?.showAlert(message: "Error occurred while trying to load launchpads")
                    
                }, onCompleted: {
                    
                    OperationQueue.main.addOperation ({
                        self?.reloadTableView(launchpads: launchpadsTemp)
                    })
                    
//                    DispatchQueue.main.async {
//                        self?.reloadTableView(launchpads: launchpadsTemp)
//                    }
                    
                }, onDisposed: {
                    
                })
                
            }
        })
    }
    
    @objc private func reloadTableView(launchpads: NSArray) {
        
        _launchpads = launchpads
        
        _launchpadListView.tableView.reloadData()
        
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
    
    private func showAlert(message: String) {
        
        DispatchQueue.main.async { [unowned self] in
            
            let alert = UIAlertController(title: "Something Goes Wrong", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
        return _launchpads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: LaunchpadCell = tableView.dequeueReusableCell(withIdentifier: _launchpadCellId, for: indexPath) as! LaunchpadCell
        let launchpad: Launchpad = _launchpads.object(at: indexPath.row) as! Launchpad
        cell.update(launchpad: launchpad)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell: LaunchpadCell = tableView.cellForRow(at: indexPath) as! LaunchpadCell
        selectedCell.setSelected(false, animated: true)
        
        let launchpad: Launchpad = _launchpads.object(at: indexPath.row) as! Launchpad
        let launchpadDetailController: LaunchpadDetailController = LaunchpadDetailController(aLaunchpad: launchpad)
        self.navigationController?.pushViewController(launchpadDetailController, animated: true)
    }
}
