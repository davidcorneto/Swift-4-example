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
    
    var _launchpad: Launchpad?
    var _launchpadDetailCellId: String!
    var _launchpadDetailTypes: NSMutableArray!
    
    var _launchpadDetailView: LaunchpadDetailView!
    
    // MARK: - Initialization

    public init(aLaunchpad: Launchpad) {
        super.init(nibName: nil, bundle: nil)
        
        _launchpad = aLaunchpad
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func commonInit() {
        
        title = _launchpad?.fullName
        
        _launchpadDetailTypes = NSMutableArray()
        _launchpadDetailTypes.add(TypeConstants.LaunchpadDetailType.location)
        _launchpadDetailTypes.add(TypeConstants.LaunchpadDetailType.region)
        _launchpadDetailTypes.add(TypeConstants.LaunchpadDetailType.details)
        
        _launchpadDetailCellId = "launchpadDetailCellId"
        
        _launchpadDetailView = LaunchpadDetailView()
        _launchpadDetailView.tableView.register(LaunchpadDetailCell.self, forCellReuseIdentifier: _launchpadDetailCellId)
    }
    
    // MARK: - Life cycle
    
    override func loadView() {
        view = _launchpadDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadTableView()
    }
    
    // MARK: - Private methods
    
    private func reloadTableView() {
        
        if (_launchpadDetailView.tableView.delegate == nil) {
            _launchpadDetailView.tableView.delegate = self
        }
        
        if (_launchpadDetailView.tableView.dataSource == nil) {
            _launchpadDetailView.tableView.dataSource = self
        }
        
        _launchpadDetailView.tableView.reloadData()
    }
}

// MARK: - Table View delegate & data source

extension LaunchpadDetailController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _launchpadDetailTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: LaunchpadDetailCell = tableView.dequeueReusableCell(withIdentifier: _launchpadDetailCellId, for: indexPath) as! LaunchpadDetailCell
        
        if let launchpad = _launchpad {
            
            if (TypeConstants.LaunchpadDetailType(rawValue: indexPath.row) == TypeConstants.LaunchpadDetailType.location) {
                cell.update(launchpad: launchpad, type:TypeConstants.LaunchpadDetailType.location)
                
            } else if (TypeConstants.LaunchpadDetailType(rawValue: indexPath.row) == TypeConstants.LaunchpadDetailType.region) {
                cell.update(launchpad: launchpad, type: TypeConstants.LaunchpadDetailType.region)
                
            } else if (TypeConstants.LaunchpadDetailType(rawValue: indexPath.row) == TypeConstants.LaunchpadDetailType.details) {
                cell.update(launchpad: launchpad, type: TypeConstants.LaunchpadDetailType.details)
                
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (TypeConstants.LaunchpadDetailType(rawValue: indexPath.row) == TypeConstants.LaunchpadDetailType.location || TypeConstants.LaunchpadDetailType(rawValue: indexPath.row) == TypeConstants.LaunchpadDetailType.region) {
            
            return 65.0
            
        } else {
            // Details: could be more than one line
            
            let contentHeight: CGFloat = (_launchpad?.details.height(withConstrainedWidth: UIScreen.main.bounds.size.width - LaunchpadDetailCell.sideOffset * 2, font: LaunchpadDetailCell.contentFont))!
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
