//
//  LaunchpadListView.swift
//  Launchpads
//
//  Created by Alexey Gross on 27.11.17.
//  Copyright © 2017 gross. All rights reserved.
//

import UIKit

class LaunchpadListView: UIView {
    
    // MARK: - Properties
    
    var tableView: UITableView!
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        tableView = UITableView(frame: CGRect.zero)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        addSubview(tableView)
    }
    
    // MARK: - Layouts
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: frame.size.width,
                                 height: frame.size.height)
    }
}

