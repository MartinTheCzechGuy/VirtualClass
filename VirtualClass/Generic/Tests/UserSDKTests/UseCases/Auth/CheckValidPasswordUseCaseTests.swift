//
//  CheckValidPasswordUseCaseTests.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import Foundation
import XCTest
@testable import UserSDK

final class CheckValidPasswordUseCaseTests: XCTestCase {
    func test_valid_addresses() {
        let sut = CheckValidPasswordUseCase()
                
        XCTAssertTrue(sut.isValid(password: "dfsfsdi89897"))
        XCTAssertTrue(sut.isValid(password: "dfghjklpoiuztre"))
    }
    
    func test_invalid_addresses() {
        let sut = CheckValidPasswordUseCase()
        
        XCTAssertFalse(sut.isValid(password: ""))
        XCTAssertFalse(sut.isValid(password: "fsfdsfsdffsfsafasfsdfsafdsfdsfsfsa"))
    }
}
