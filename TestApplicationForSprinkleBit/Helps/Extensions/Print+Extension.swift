//
//  Print+Extension.swift
//  TestApplicationForSprinkleBit
//
//  Created by Dennis Ritchie on 12/10/17.
//  Copyright © 2017 Dennis Ritchie. All rights reserved.
//

import UIKit

func myPrint(_ value: Any?, file: String = #file, lineNumber: Int = #line) {
    #if DEBUG
        let fName = fileName(from: file)
        
        let printValue: Any = value ?? "value is nil"
        print("\n~~ [\(fName): \(lineNumber)]  \(printValue)")
    #endif
}

func fileName(from path: String) -> String {
    let components = path.components(separatedBy: "/")
    guard let last = components.last else {
        return ""
    }
    
    return last
}

