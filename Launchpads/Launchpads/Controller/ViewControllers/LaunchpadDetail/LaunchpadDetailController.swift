//
//  LaunchpadDetailController.swift
//  Launchpads
//
//  Created by Alexey Gross on 27.11.17.
//  Copyright © 2017 gross. All rights reserved.
//

import UIKit

class LaunchpadDetailController: UIViewController {
    
    // MARK: - Properties
    
    var launchpad: Launchpad?
    var launchpadDetailCellId: String!
    var launchpadDetailTypes: NSMutableArray!
    
    var launchpadDetailView: LaunchpadDetailView!
    
    // MARK: - Initialization

    public init(aLaunchpad: Launchpad) {
        super.init(nibName: nil, bundle: nil)
        
        launchpad = aLaunchpad
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func commonInit() {
        
        title = launchpad?.fullName
        
        launchpadDetailTypes = NSMutableArray()
        launchpadDetailTypes.add(TypeConstants.LaunchpadDetailType.location)
        launchpadDetailTypes.add(TypeConstants.LaunchpadDetailType.region)
        launchpadDetailTypes.add(TypeConstants.LaunchpadDetailType.details)
        
        launchpadDetailCellId = "launchpadDetailCellId"
        
        launchpadDetailView = LaunchpadDetailView()
        launchpadDetailView.tableView.register(LaunchpadDetailCell.self, forCellReuseIdentifier: launchpadDetailCellId)
    }
    
    // MARK: - Life cycle
    
    override func loadView() {
        view = launchpadDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadTableView()
    }
    
    // MARK: - Private methods
    
    private func reloadTableView() {
        
        if (launchpadDetailView.tableView.delegate == nil) {
            self.launchpadDetailView.tableView.delegate = self
        }
        
        if (launchpadDetailView.tableView.dataSource == nil) {
            self.launchpadDetailView.tableView.dataSource = self
        }
        
        self.launchpadDetailView.tableView.reloadData()
    }
}

// MARK: - Table View delegate & data source

extension LaunchpadDetailController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return launchpadDetailTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: LaunchpadDetailCell = tableView.dequeueReusableCell(withIdentifier: launchpadDetailCellId, for: indexPath) as! LaunchpadDetailCell
        
        if let aLaunchpad: Launchpad = launchpad {
            
            if (TypeConstants.LaunchpadDetailType(rawValue: indexPath.row) == TypeConstants.LaunchpadDetailType.location) {
                cell.update(launchpad: aLaunchpad, type:TypeConstants.LaunchpadDetailType.location)
                
            } else if (TypeConstants.LaunchpadDetailType(rawValue: indexPath.row) == TypeConstants.LaunchpadDetailType.region) {
                cell.update(launchpad: aLaunchpad, type: TypeConstants.LaunchpadDetailType.region)
                
            } else if (TypeConstants.LaunchpadDetailType(rawValue: indexPath.row) == TypeConstants.LaunchpadDetailType.details) {
                cell.update(launchpad: aLaunchpad, type: TypeConstants.LaunchpadDetailType.details)
                
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (TypeConstants.LaunchpadDetailType(rawValue: indexPath.row) == TypeConstants.LaunchpadDetailType.location || TypeConstants.LaunchpadDetailType(rawValue: indexPath.row) == TypeConstants.LaunchpadDetailType.region) {
            
            return 65.0
            
        } else {
            // Details: could be more than one line
            
            let contentHeight: CGFloat = (launchpad?.details.height(withConstrainedWidth: UIScreen.main.bounds.size.width - LaunchpadDetailCell.sideOffset * 2, font: LaunchpadDetailCell.contentFont))!
            let titleString: String = LaunchpadDetailCell.titleForType(type: TypeConstants.LaunchpadDetailType(rawValue: indexPath.row)!)
            let titleHeight: CGFloat = titleString.height(withConstrainedWidth: UIScreen.main.bounds.size.width - LaunchpadDetailCell.sideOffset * 2, font: LaunchpadDetailCell.headerFont)
            
            return contentHeight + titleHeight + LaunchpadDetailCell.topBottomOffset * 2 + LaunchpadDetailCell.contentTopOffset
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell: LaunchpadDetailCell = tableView.cellForRow(at: indexPath) as! LaunchpadDetailCell
        selectedCell.setSelected(false, animated: true)
    }
}
