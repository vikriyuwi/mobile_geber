//
//  BiometricAuthService.swift
//  geber
//
//  Created by Vikri Yuwi on 22/03/25.
//

import LocalAuthentication

class BiometricAuthService: BiometricAuthServiceProtocol {
    static let shared = BiometricAuthService()
    
    private init() {}

    func authenticateUser(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        // Check if biometric authentication is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Face ID or Touch ID is required to proceed."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        } else {
            DispatchQueue.main.async {
                completion(false)
            }
        }
    }
}
