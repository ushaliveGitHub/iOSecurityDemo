//
//  Authorization.swift
//  securityIniOS
//
//  Created by Usha Natarajan on 9/2/18.
//  Copyright © 2018 Usha Natarajan. All rights reserved.
//

import Foundation
import CryptoSwift

final class Authorization{
    class func passwordHash(from user:String,password:String)->String{
        let salt = valueForKey(resource: "Salt", keyname: "Salt")
        return "\(password).\(user).\(salt)".sha256()
    }
    
}
