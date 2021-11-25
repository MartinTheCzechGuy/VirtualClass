//
//  UserDBRepositoryTests.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import XCTest
@testable import Database

final class UserDBRepositoryTests: XCTestCase {
    
    func testSaveGenericPassword() {
        let sut = try? UserDBRepository(name: "DataModel", bundle: .module, inMemory: true)
        
        XCTAssertNotNil(sut)
        
        let domainModel = DomainUserModel(id: UUID(), name: "Franta", email: "Franta")
        
        let result = sut!.create(domainModel: domainModel)
        
        if case .success = result {
            XCTAssertTrue(true)
        } else {
            XCTFail()
        }        
    }
}
