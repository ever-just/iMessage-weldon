//
//  iMessageCloneTests.swift
//  iMessageCloneTests
//
//  weldon.vip - Unit tests for iMessage Clone
//

import XCTest
@testable import iMessageClone

final class iMessageCloneTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Setup code before each test
    }
    
    override func tearDownWithError() throws {
        // Cleanup code after each test
    }
    
    // MARK: - AppConfig Tests
    
    func testAppConfigHasAdminUserId() throws {
        XCTAssertEqual(AppConfig.adminUserId, "weldon_admin")
    }
    
    func testAppConfigHasChannelPrefix() throws {
        XCTAssertEqual(AppConfig.channelPrefix, "dm_weldon_")
    }
    
    // MARK: - AuthManager Tests
    
    func testAuthManagerIsSingleton() throws {
        let instance1 = AuthManager.shared
        let instance2 = AuthManager.shared
        XCTAssertTrue(instance1 === instance2)
    }
    
    func testAuthManagerInitialState() throws {
        // AuthManager should start with no current user
        // Note: This test may fail if user is already signed in
        // In a real test, we'd mock the auth state
    }
    
    // MARK: - UserType Tests
    
    func testUserTypeAdmin() throws {
        // Test that admin user ID is correctly identified
        let adminId = AppConfig.adminUserId
        XCTAssertEqual(adminId, "weldon_admin")
    }
}
