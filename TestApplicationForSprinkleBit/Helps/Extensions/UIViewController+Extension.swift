//
//  UIViewController+Extension.swift
//  TestApplicationForSprinkleBit
//
//  Created by Dennis Ritchie on 12/10/17.
//  Copyright © 2017 Dennis Ritchie. All rights reserved.
//

import UIKit
import DPLocalization

extension UIViewController {
    
    func showMessage(title: String? = nil, text: String) {
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: DPAutolocalizedString("ok_btn", nil), style: .cancel))
        self.present(alertController, animated: true)
    }
}
