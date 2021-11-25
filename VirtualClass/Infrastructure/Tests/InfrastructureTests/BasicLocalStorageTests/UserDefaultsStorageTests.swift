//
//  UserDefaultsStorageTests.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import XCTest
@testable import BasicLocalStorage

final class UserDefaultsStorageTests: XCTestCase {
    
    private var storage: UserDefaultsStorage?
    
    override func setUp() {
        super.setUp()
        
        storage = UserDefaultsStorage()
    }
    
    override func tearDown() {
        storage?.clearStorage()
        
        super.tearDown()
    }
    
    func testExample() {
        let value = "value"
        let key = "key"
        
        storage?.set(value, for: .userEmail)
        
        let result: String? = storage?.read(objectForKey: .userEmail)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result, value)
    }
}
