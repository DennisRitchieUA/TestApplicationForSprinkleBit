//
//  ErrorManager.swift
//  TestApplicationForSprinkleBit
//
//  Created by Dennis Ritchie on 12/10/17.
//  Copyright © 2017 Dennis Ritchie. All rights reserved.
//

import UIKit

class ErrorManager: NSObject {
    class func createError(_ errorText: String, code: Int) -> NSError {
        let error = NSError(domain: "ErrorDomain", code: code, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString(errorText, comment: "ErrorText"), NSLocalizedFailureReasonErrorKey:NSLocalizedString(errorText, comment: "ErrorText")])
        return error
    }
}
