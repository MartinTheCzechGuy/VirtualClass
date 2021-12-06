//
//  GetLoggedInUserUseCaseTests.swift
//
//
//  Created by Martin on 26.11.2021.
//

import Combine
import Foundation
import XCTest
@testable import UserSDK

final class GetLoggedInUserUseCaseTests: XCTestCase {
    
    private var bag = Set<AnyCancellable>()
    
    override func tearDown() {
        bag.removeAll()
        
        super.tearDown()
    }
    
    func test_load_existing_user_email() {
        let email = "email"
        let authRepository = UserAuthRepositoryStub(
            results: .mock(
                loggedInUserEmail: "email"
            )
        )
       
        let sut = GetLoggedInUserUseCase(authRepository: authRepository)
        
        XCTAssertEqual(sut.email, email)
    }
    
    func test_load_nil_for_non_existing_user() {
        let authRepository = UserAuthRepositoryStub(
            results: .mock(
                loggedInUserEmail: nil
            )
        )
       
        let sut = GetLoggedInUserUseCase(authRepository: authRepository)
        
        XCTAssertNil(sut.email)
    }
}
