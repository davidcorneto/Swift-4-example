//
//  LaunchpadDetailCell.swift
//  Launchpads
//
//  Created by Alexey Gross on 30.11.17.
//  Copyright © 2017 gross. All rights reserved.
//

import UIKit

class LaunchpadDetailCell: UITableViewCell {
    
    // MARK: - Properties
    
    var headerLabel: UILabel!
    var contentLabel: UILabel!
    var separatorLine: UIView!
    
    // MARK: - Initialization
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        headerLabel = UILabel(frame: CGRect.zero)
        headerLabel.textAlignment = NSTextAlignment.left
        headerLabel.font = LaunchpadDetailCell.headerFont
        addSubview(headerLabel)
        
        contentLabel = UILabel(frame: CGRect.zero)
        contentLabel.font = LaunchpadDetailCell.contentFont
        contentLabel.numberOfLines = 0
        addSubview(contentLabel)
        
        separatorLine = UIView(frame: CGRect.zero)
        separatorLine.backgroundColor = UIColor.gray
        addSubview(separatorLine)
    }
    
    // MARK: - update
    
    func update(launchpad: Launchpad, type: TypeConstants.LaunchpadDetailType) {
        
        if (type == TypeConstants.LaunchpadDetailType.location) {
            
            headerLabel.text = LaunchpadDetailCell.titleForType(type: type)
            contentLabel.text = launchpad.location.name
            
        } else if (type == TypeConstants.LaunchpadDetailType.region) {
            
            headerLabel.text = LaunchpadDetailCell.titleForType(type: type)
            contentLabel.text = launchpad.location.region
            
        } else if (type == TypeConstants.LaunchpadDetailType.details) {
            
            headerLabel.text = LaunchpadDetailCell.titleForType(type: type)
            contentLabel.text = launchpad.details
            
        }
        
        self.layoutIfNeeded()
    }
    
    // MARK: - layouts
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let separatorLineHeight: CGFloat = 1.0 / UIScreen.main.scale
        
        
        headerLabel.sizeToFit()
        headerLabel.frame = CGRect(x: LaunchpadDetailCell.sideOffset,
                                   y: LaunchpadDetailCell.topBottomOffset,
                                   width: self.frame.size.width - LaunchpadDetailCell.sideOffset * 2,
                                   height: headerLabel.frame.size.height)
        
        
        contentLabel.sizeToFit()
        contentLabel.frame = CGRect(x: LaunchpadDetailCell.sideOffset,
                                    y: headerLabel.frame.origin.y + headerLabel.frame.size.height + LaunchpadDetailCell.contentTopOffset,
                                    width: self.frame.size.width - LaunchpadDetailCell.sideOffset * 2,
                                    height: contentLabel.frame.size.height)
        
        
        separatorLine.frame = CGRect(x: 0,
                                     y: self.frame.size.height - separatorLineHeight,
                                     width: self.frame.size.width,
                                     height: separatorLineHeight)
    }
}


extension LaunchpadDetailCell {

    // MARK: - Constants
    // Required for text height calculation
    
    static let headerFont: UIFont = UIFont.systemFont(ofSize: 12)
    
    static let contentFont: UIFont = UIFont.systemFont(ofSize: 18)
    static let sideOffset: CGFloat = 10
    static let contentTopOffset: CGFloat = 5
    
    static let topBottomOffset: CGFloat = 10
    
    static func titleForType(type: TypeConstants.LaunchpadDetailType) -> String {
        
        if (type == TypeConstants.LaunchpadDetailType.location) {
            return "Location:"
            
        } else if (type == TypeConstants.LaunchpadDetailType.region) {
            return "Region:"
            
        } else if (type == TypeConstants.LaunchpadDetailType.details) {
            return "Details:"
            
        } else {
            return ""
        }
    }
}
