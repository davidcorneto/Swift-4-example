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
    
    var _mainTitleLabel: UILabel!
    var _subTitleLabel: UILabel!
    var _separatorLine: UIView!
    
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
        
        _mainTitleLabel = UILabel(frame: CGRect.zero)
        _mainTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        _mainTitleLabel.numberOfLines = 0
        _mainTitleLabel.textColor = UIColor(rgb: 0x313131)
        addSubview(_mainTitleLabel)
        
        _subTitleLabel = UILabel(frame: CGRect.zero)
        _subTitleLabel.font = UIFont.systemFont(ofSize: 10)
        addSubview(_subTitleLabel)
        
        _separatorLine = UIView(frame: CGRect.zero)
        _separatorLine.backgroundColor = UIColor.gray
        addSubview(_separatorLine)
    }
    
    // MARK: - update
    
    func update(launchpad: Launchpad) {
        
        _mainTitleLabel.text = launchpad.fullName
        _subTitleLabel.text = launchpad.status
        
        updateSubtitleColors(launchpad: launchpad)
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func updateSubtitleColors(launchpad: Launchpad) {
        if (launchpad.status == "retired") {
            _subTitleLabel.textColor = UIColor(rgb: 0xcf1b1b)
        }
        
        if (launchpad.status == "active") {
            _subTitleLabel.textColor = UIColor(rgb: 0x19774d)
        }
        
        if (launchpad.status == "under construction") {
            _subTitleLabel.textColor = UIColor(rgb: 0x32009f)
        }
    }
    
    // MARK: - layouts
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        _mainTitleLabel.sizeToFit()
        _mainTitleLabel.frame = CGRect(x: LayoutConfigs.mainTitleLabel_sideOffset,
                                       y: LayoutConfigs.mainTitleLabel_topOffset,
                                       width: frame.size.width - LayoutConfigs.mainTitleLabel_sideOffset * 2,
                                       height: _mainTitleLabel.frame.size.height)
        
        
        _subTitleLabel.sizeToFit()
        _subTitleLabel.frame = CGRect(x: _mainTitleLabel.frame.origin.x,
                                      y: frame.size.height - _subTitleLabel.frame.size.height - LayoutConfigs.subtitleLabel_bottomOffset,
                                      width: _mainTitleLabel.frame.size.width,
                                      height: _subTitleLabel.frame.size.height)
        
        
        _separatorLine.frame = CGRect(x: 0,
                                      y: frame.size.height - LayoutConfigs.separatorLine_height,
                                      width: frame.size.width,
                                      height: LayoutConfigs.separatorLine_height)
    }
    
    // MARK: - Layout configs
    
    private struct LayoutConfigs {
        
        static let mainTitleLabel_sideOffset: CGFloat = 10.0
        static let mainTitleLabel_topOffset: CGFloat = 10.0
        
        static let subtitleLabel_bottomOffset: CGFloat = 5.0
        
        static let separatorLine_height: CGFloat = 1.0 / UIScreen.main.scale
    }
}
