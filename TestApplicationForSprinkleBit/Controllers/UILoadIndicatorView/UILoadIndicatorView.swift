//
//  UILoadIndicatorView.swift
//  TestApplicationForSprinkleBit
//
//  Created by Dennis Ritchie on 12/11/17.
//  Copyright © 2017 Dennis Ritchie. All rights reserved.
//

import UIKit

class UILoadIndicatorView: UIView {
    // MARK: - Properties
    private var activityIndicator = UIActivityIndicatorView()
    
    // MARK: - UILoadIndicatorView lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    // MARK: - UILoadIndicatorView interface setting
    private func setupView() {
        self.activityIndicator.activityIndicatorViewStyle = .gray
        self.activityIndicator.center = self.center
        self.addSubview(self.activityIndicator)
    }
    
    // MARK: - UILoadIndicatorView actions
    func beginAnimateion() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimateion() {
        activityIndicator.stopAnimating()
    }
}
