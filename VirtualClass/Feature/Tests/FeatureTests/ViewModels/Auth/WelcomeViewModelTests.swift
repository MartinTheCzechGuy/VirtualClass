//
//  WelcomeViewModelTests.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import XCTest
@testable import Auth

final class WelcomeViewModelTests: XCTestCase {
    
    private var bag = Set<AnyCancellable>()
    
    override func tearDown() {
        bag.removeAll()
        
        super.tearDown()
    }
    
    func test_handle_login_tap() {
        let sut = WelcomeViewModel()
        
        let expectation = expectation(description: "Login tap handled")
        
        sut.actions.loginTap
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.signInTap.send(())
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_handle_registration_tap() {
        let sut = WelcomeViewModel()
        
        let expectation = expectation(description: "Registration tap handled")
        
        sut.actions.registrationTap
            .sink(
                receiveCompletion: { completion in
                    XCTFail()
                },
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.signUpTap.send(())
        
        waitForExpectations(timeout: 0.1)
    }
}
