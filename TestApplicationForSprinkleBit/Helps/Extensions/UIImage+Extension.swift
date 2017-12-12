//
//  UIImage+Extension.swift
//  TestApplicationForSprinkleBit
//
//  Created by Dennis Ritchie on 12/10/17.
//  Copyright © 2017 Dennis Ritchie. All rights reserved.
//

import UIKit

extension UIImage {
    static func imageWithColor(color: UIColor, height: CGFloat, lineHeight: CGFloat) -> UIImage {
        let rect = CGRect(x: 0.0, y: height-lineHeight, width: 1.0, height: lineHeight)
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: height))
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
        
    }
}
