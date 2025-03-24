import XCTest
import LocalAuthentication
@testable import geber

class MockLAContext: LAContext {
    var canEvaluatePolicyResult = true
    var evaluatePolicySuccess = true
    
    override func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool {
        return canEvaluatePolicyResult
    }
    
    override func evaluatePolicy(_ policy: LAPolicy, localizedReason: String, reply: @escaping (Bool, Error?) -> Void) {
        reply(evaluatePolicySuccess, nil)
    }
}

class BiometricAuthServiceTest: XCTestCase {
    var biometricAuthService: BiometricAuthService!
    var mockContext: MockLAContext!
    
    override func setUp() {
        super.setUp()
        biometricAuthService = BiometricAuthService.shared
        mockContext = MockLAContext()
    }
    
    override func tearDown() {
        biometricAuthService = nil
        mockContext = nil
        super.tearDown()
    }
    
    func testAuthenticationSuccess() {
        mockContext.evaluatePolicySuccess = true
        
        let expectation = self.expectation(description: "Authentication should succeed")
        
        biometricAuthService.authenticateUser { success in
            XCTAssertTrue(success, "Expected authentication to succeed")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testAuthenticationFailure() {
        mockContext.evaluatePolicySuccess = false
        
        let expectation = self.expectation(description: "Authentication should fail")
        
        biometricAuthService.authenticateUser { success in
            XCTAssertFalse(success, "Expected authentication to fail")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testBiometricUnavailable() {
        mockContext.canEvaluatePolicyResult = false
        
        let expectation = self.expectation(description: "Biometric authentication should be unavailable")
        
        biometricAuthService.authenticateUser { success in
            XCTAssertFalse(success, "Expected biometric authentication to be unavailable")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
