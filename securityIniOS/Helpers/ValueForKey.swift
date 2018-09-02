//
//  ValueForKey.swift
//  securityIniOS
//
//  Created by Usha Natarajan on 9/2/18.
//  Copyright © 2018 Usha Natarajan. All rights reserved.
//

import Foundation

func valueForKey(resource:String,keyname:String) -> Any {
    // Get the file path for keys.plist
    let filePath = Bundle.main.path(forResource: resource, ofType: "plist")
    
    // Put the keys in a dictionary
    let plist = NSDictionary(contentsOfFile: filePath!)
    
    // Pull the value for the key
    let value = plist?.object(forKey: keyname)
    return value as Any
}
