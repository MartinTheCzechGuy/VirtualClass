//
//  SecureStorageTests.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import XCTest
@testable import SecureStorage

final class SecureStorageTests: XCTestCase {
    
    private var secureStorage: KeychainStorage?
    
    override func setUp() {
        super.setUp()
        
        let passwordQueryable = UserPassword(service: "service", accessGroup: "tada")
        secureStorage = KeychainStorage(secureStoreQueryable: passwordQueryable)
    }
    
    override func tearDown() {
        try? secureStorage?.removeAllValues()
        
        super.tearDown()
    }
    
    func testSaveGenericPassword() {
//        let value = "my password"
//        let key = "password key"
//        
//        secureStorage?.setValue(value, for: key)

        do {
            try secureStorage?.setValue("pwd_1234", for: "genericPassword")
        } catch (let e) {
            XCTFail("Saving generic password failed with \(e.localizedDescription).")
        }
    }
    
    func testReadGenericPassword() {
        do {
            try secureStorage?.setValue("pwd_1234", for: "genericPassword")
            let password = try secureStorage?.getValue(for: "genericPassword")
            XCTAssertEqual("pwd_1234", password)
        } catch (let e) {
            XCTFail("Reading generic password failed with \(e.localizedDescription).")
        }
    }
    
    func testUpdateGenericPassword() {
        do {
            try secureStorage?.setValue("pwd_1234", for: "genericPassword")
            try secureStorage?.setValue("pwd_1235", for: "genericPassword")
            let password = try secureStorage?.getValue(for: "genericPassword")
            XCTAssertEqual("pwd_1235", password)
        } catch (let e) {
            XCTFail("Updating generic password failed with \(e.localizedDescription).")
        }
    }
    
    func testRemoveGenericPassword() {
        do {
            try secureStorage?.setValue("pwd_1234", for: "genericPassword")
            try secureStorage?.removeValue(for: "genericPassword")
            XCTAssertNil(try secureStorage?.getValue(for: "genericPassword"))
        } catch (let e) {
            XCTFail("Saving generic password failed with \(e.localizedDescription).")
        }
    }
    
    func testRemoveAllGenericPasswords() {
        do {
            try secureStorage?.setValue("pwd_1234", for: "genericPassword")
            try secureStorage?.setValue("pwd_1235", for: "genericPassword2")
            try secureStorage?.removeAllValues()
            XCTAssertNil(try secureStorage?.getValue(for: "genericPassword"))
            XCTAssertNil(try secureStorage?.getValue(for: "genericPassword2"))
        } catch (let e) {
            XCTFail("Removing generic passwords failed with \(e.localizedDescription).")
        }
    }
}
