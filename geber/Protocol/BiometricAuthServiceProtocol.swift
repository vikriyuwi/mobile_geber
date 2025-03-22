import SwiftUI
import LocalAuthentication

protocol BiometricAuthServiceProtocol {
    func authenticateUser(completion: @escaping (Bool) -> Void)
}
