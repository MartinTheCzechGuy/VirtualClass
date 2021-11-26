//
//  CheckValidEmailUseCaseTests.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import Foundation
import XCTest
@testable import UserSDK

final class CheckValidEmailUseCaseTests: XCTestCase {
    func test_valid_addresses() {
        let sut = CheckValidEmailUseCase()
                
        XCTAssertTrue(sut.isValid(email: "abc-d@mail.com"))
        XCTAssertTrue(sut.isValid(email: "abc.def@mail.com"))
        XCTAssertTrue(sut.isValid(email: "abc@mail.com"))
        XCTAssertTrue(sut.isValid(email: "abc_def@mail.com"))
        XCTAssertTrue(sut.isValid(email: "abc.def@mail.cc"))
        XCTAssertTrue(sut.isValid(email: "abc.def@mail-archive.com"))
        XCTAssertTrue(sut.isValid(email: "abc.def@mail.org"))
        XCTAssertTrue(sut.isValid(email: "abc.def@mail.com"))
    }
    
    func test_invalid_addresses() {
        let sut = CheckValidEmailUseCase()
        
        XCTAssertFalse(sut.isValid(email: "abc..def@mail.com"))
        XCTAssertFalse(sut.isValid(email: ".abc@mail.com"))
        XCTAssertFalse(sut.isValid(email: "abc.def@mail#archive.com"))
        XCTAssertFalse(sut.isValid(email: "abc.def@mail"))
        XCTAssertFalse(sut.isValid(email: "abc.def@mail..com"))
        XCTAssertFalse(sut.isValid(email: ""))
    }
}
