//
//  CustomUISegmnentControll.swift
//  TestApplicationForSprinkleBit
//
//  Created by Dennis Ritchie on 12/10/17.
//  Copyright © 2017 Dennis Ritchie. All rights reserved.
//

import UIKit

class CustomUISegmnentControll: UISegmentedControl {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupStyle()
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        self.setupStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupStyle()
    }
    
    private func setupStyle() {
        self.backgroundColor = UIColor.clear
        
        self.setDividerImage(UIImage(), forLeftSegmentState: .normal,
                             rightSegmentState: .normal,
                             barMetrics: .default)
        
        self.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0, weight: .regular),
                                     NSAttributedStringKey.foregroundColor: UIColor.black],
                                    for: .normal)
        self.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0, weight: .regular),
                                     NSAttributedStringKey.foregroundColor: UIColor.white],
                                    for: .selected)
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 2
        self.layer.borderWidth = 1
        self.setBackgroundImage(UIImage.imageWithColor(color: UIColor.clear,
                                                       height: 29.0,
                                                       lineHeight: 29.0), for: .normal,
                                                                          barMetrics: .default)
        self.setBackgroundImage(UIImage.imageWithColor(color: UIColor.black,
                                                       height: 29.0,
                                                       lineHeight: 29.0),
                                for: .selected,
                                barMetrics: .default)
    }
    
}
