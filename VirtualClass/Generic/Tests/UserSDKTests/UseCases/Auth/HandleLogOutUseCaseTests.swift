//
//  HandleLogOutUseCaseTests.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import Foundation
import XCTest
@testable import UserSDK

final class HandleLogOutUseCaseTests: XCTestCase {
    func test_logout() {
        let userAuthRepository = UserAuthRepositoryStub(results: .mock())
        let sut = HandleLogOutUseCase(userAuthRepository: userAuthRepository)
        
        sut.logout()
        
        XCTAssertTrue(true)
    }
}
