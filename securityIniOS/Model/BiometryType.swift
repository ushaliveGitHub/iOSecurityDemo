//
//  BiometryType.swift
//  securityIniOS
//
//  Created by Usha Natarajan on 8/30/18.
//  Copyright © 2018 Usha Natarajan. All rights reserved.
//

import Foundation
import LocalAuthentication

enum BiometryType{
    case touchID
    case faceID
    case login
    
    var image:String{
        switch self{
        case .touchID: return "touchID"
        case .faceID: return "faceID"
        case .login: return "login"
        }
    }
}

class BiometricID{
    let context = LAContext() //Local Authentication Context
    var loginReason = "Logging in with Touch ID"
    
    func canEvalutePolicy()->Bool{
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func bioMetericType()->BiometryType{
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType{
            case .none:
                return .login
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
        }

    }
    
    
    func authencateUser(completion: @escaping(String?)->Void){
        guard canEvalutePolicy() else{
            completion("Biometric authentication not available")
            return
        }
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: loginReason) { (success, error) in
            
            if success{
                DispatchQueue.main.sync{
                    completion(nil)
                }
            }else{
                let message:String
                switch error{
                    case LAError.authenticationFailed?:
                        message = "There was a proble verifying your identity."
                    case LAError.biometryLockout?:
                        message = "Too many failed attempts. Face/Touch ID lockout."
                    case LAError.biometryNotAvailable?:
                         message = "Face/Touch ID is not availble on your device now."
                    case LAError.biometryNotAvailable?:
                         message = "Face/Touch ID is not setup on your device."
                    case LAError.userCancel?:
                        message = "You pressed cancel"
                    case LAError.userFallback?:
                        message = "You pressed password"
                    default:
                        message = "Biometric Authentication may not be configured on your device."
                }
                completion(message)
            }
        }
    }//end of authenticateUser
}
