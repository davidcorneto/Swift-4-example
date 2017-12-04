//
//  LaunchpadCell.swift
//  Launchpads
//
//  Created by Alexey Gross on 29.11.17.
//  Copyright © 2017 gross. All rights reserved.
//

import UIKit

class LaunchpadCell: UITableViewCell {
    
    // MARK: - Properties
    
    var mainTitleLabel: UILabel!
    var subTitleLabel: UILabel!
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
        
        mainTitleLabel = UILabel(frame: CGRect.zero)
        mainTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        mainTitleLabel.numberOfLines = 0
        mainTitleLabel.textColor = UIColor(rgb: 0x313131)
        addSubview(mainTitleLabel)
        
        subTitleLabel = UILabel(frame: CGRect.zero)
        subTitleLabel.font = UIFont.systemFont(ofSize: 10)
        addSubview(subTitleLabel)
        
        separatorLine = UIView(frame: CGRect.zero)
        separatorLine.backgroundColor = UIColor.gray
        addSubview(separatorLine)
    }
    
    // MARK: - update
    
    func update(launchpad: Launchpad) {
        
        mainTitleLabel.text = launchpad.fullName
        subTitleLabel.text = launchpad.status
        
        self.updateSubtitleColors(launchpad: launchpad)
        
        self.layoutIfNeeded()
    }
    
    func updateSubtitleColors(launchpad: Launchpad) {
        if (launchpad.status == "retired") {
            subTitleLabel.textColor = UIColor(rgb: 0xcf1b1b)
        }
        
        if (launchpad.status == "active") {
            subTitleLabel.textColor = UIColor(rgb: 0x19774d)
        }
        
        if (launchpad.status == "under construction") {
            subTitleLabel.textColor = UIColor(rgb: 0x32009f)
        }
    }
    
    // MARK: - layouts
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let titleSideOffset: CGFloat = 10.0
        let mainTitleTopOffset: CGFloat = 10.0
        let subTitleBottomOffset: CGFloat = 5.0
        
        let separatorLineHeight: CGFloat = 1.0 / UIScreen.main.scale
        
        
        mainTitleLabel.sizeToFit()
        mainTitleLabel.frame = CGRect(x: titleSideOffset,
                                      y: mainTitleTopOffset,
                                      width: self.frame.size.width - titleSideOffset * 2,
                                      height: mainTitleLabel.frame.size.height)
        
        
        subTitleLabel.sizeToFit()
        subTitleLabel.frame = CGRect(x: mainTitleLabel.frame.origin.x,
                                     y: self.frame.size.height - subTitleLabel.frame.size.height - subTitleBottomOffset,
                                     width: mainTitleLabel.frame.size.width,
                                     height: subTitleLabel.frame.size.height)
        
        
        separatorLine.frame = CGRect(x: 0,
                                     y: self.frame.size.height - separatorLineHeight,
                                     width: self.frame.size.width,
                                     height: separatorLineHeight)
    }
}
