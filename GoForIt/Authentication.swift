//
//  Authentication.swift
//  GoForIt
//
//  Created by Lidner on 14/9/20.
//  Copyright (c) 2014 Solfanto. All rights reserved.
//

import UIKit

private let _authenticationInstance = Authentication()
class Authentication {
    private var _uuid: String!
    
    class var sharedInstance: Authentication {
        return _authenticationInstance
    }
    
    init() {
        
    }
    
    func uuid() -> String {
        if _uuid != nil {
            return _uuid
        }
        _uuid = NSUserDefaults.standardUserDefaults().valueForKey("uuid") as? String
        if _uuid != nil {
            return _uuid
        }
        _uuid = NSUUID.UUID().UUIDString
        setUuid(_uuid)
        return _uuid
    }
    
    func setUuid(value: String) {
        NSUserDefaults.standardUserDefaults().setValue(value, forKey: "uuid")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}