//
//  NoDataView.swift
//  TestApplicationForSprinkleBit
//
//  Created by Dennis Ritchie on 12/10/17.
//  Copyright © 2017 Dennis Ritchie. All rights reserved.
//

import UIKit

class NoDataView: UIView {
    
    // MARK: - NoDataView lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - NoDataView load static
    static func loadNoDataViewFromXib(frame: CGRect) -> NoDataView {
        let noDataView = Bundle.main.loadNibNamed("NoDataView", owner: self, options: nil)?.first as! NoDataView
        noDataView.frame = frame
        return noDataView
    }
    
}
