//
//  UpdatePersonalInfoViewModelTests.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import UserSDK
import XCTest
@testable import UserAccount

final class UpdatePersonalInfoViewModelTests: XCTestCase {
    
    private var bag = Set<AnyCancellable>()
    
    override func tearDown() {
        bag.removeAll()
        
        super.tearDown()
    }
    
    func test_reload_profile_success() {
        let profile: GenericStudent? = GenericStudent(
            id: UUID(),
            name: "name",
            email: "email",
            activeCourses: [],
            completedCourses: []
        )
        let getProfilePublisher = Just(profile)
            .setFailureType(to: GetStudentProfileError.self)
            .eraseToAnyPublisher()
        let updateProfilePublisher = Empty<Void, StudentRepositoryError>()
            .eraseToAnyPublisher()
        let getProfileUseCase = GetStudentProfileUseCaseStub(profile: getProfilePublisher)
        let updateProfileUseCase = UpdateStudentProfileUseCaseStub(result: updateProfilePublisher)
        
        let sut = UpdatePersonalInfoViewModel(
            getUserProfileUseCase: getProfileUseCase,
            updateStudentProfileUseCase: updateProfileUseCase
        )
        
        let expectation = expectation(description: "Data should be loaded on reload.")
        
        sut.$userInfo
            .dropFirst()
            .sink(
                receiveCompletion: { _ in
                    XCTFail()
                },
                receiveValue: { userInfo in
                    XCTAssertEqual(userInfo.name, profile?.name)
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.reloadDataSubject.send(())
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_reload_profile_failure() {
        let getProfilePublisher = Fail<GenericStudent?, GetStudentProfileError>(error: .init(cause: .emailNotFound))
            .eraseToAnyPublisher()
        let updateProfilePublisher = Empty<Void, StudentRepositoryError>()
            .eraseToAnyPublisher()
        let getProfileUseCase = GetStudentProfileUseCaseStub(profile: getProfilePublisher)
        let updateProfileUseCase = UpdateStudentProfileUseCaseStub(result: updateProfilePublisher)
        
        let sut = UpdatePersonalInfoViewModel(
            getUserProfileUseCase: getProfileUseCase,
            updateStudentProfileUseCase: updateProfileUseCase
        )
        
        let expectation = expectation(description: "The error should be suppressed.")
        expectation.isInverted = true
        
        sut.$userInfo
            .dropFirst()
            .sink(
                receiveCompletion: { _ in
                    expectation.fulfill()
                    XCTFail()
                },
                receiveValue: { _ in
                    expectation.fulfill()
                    XCTFail()
                }
            )
            .store(in: &bag)
        
        sut.reloadDataSubject.send(())
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_update_profile_success() {
        let profile: GenericStudent? = GenericStudent(
            id: UUID(),
            name: "name",
            email: "email",
            activeCourses: [],
            completedCourses: []
        )
        let getProfilePublisher = Just(profile)
            .setFailureType(to: GetStudentProfileError.self)
            .eraseToAnyPublisher()
        let updateProfilePublisher = Just(())
            .setFailureType(to: StudentRepositoryError.self)
            .eraseToAnyPublisher()
        let getProfileUseCase = GetStudentProfileUseCaseStub(profile: getProfilePublisher)
        let updateProfileUseCase = UpdateStudentProfileUseCaseStub(result: updateProfilePublisher)
        
        let sut = UpdatePersonalInfoViewModel(
            getUserProfileUseCase: getProfileUseCase,
            updateStudentProfileUseCase: updateProfileUseCase
        )
        
        let expectation = expectation(description: "Should navigate after successfull update.")
        
        sut.navigateToUserAccount
            .sink(
                receiveValue: {
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.saveChangesTap.send(())
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_update_profile_failure() {
        let getProfilePublisher = Empty<GenericStudent?, GetStudentProfileError>()
            .eraseToAnyPublisher()
        let updateProfilePublisher = Fail<Void, StudentRepositoryError>(error: .databaseError(nil))
            .eraseToAnyPublisher()
        let getProfileUseCase = GetStudentProfileUseCaseStub(profile: getProfilePublisher)
        let updateProfileUseCase = UpdateStudentProfileUseCaseStub(result: updateProfilePublisher)
        
        let sut = UpdatePersonalInfoViewModel(
            getUserProfileUseCase: getProfileUseCase,
            updateStudentProfileUseCase: updateProfileUseCase
        )
        
        let expectation = expectation(description: "Should navigate after successfull update.")
        
        sut.$errorUpdatingProfile
            .sink(
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.saveChangesTap.send(())
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_handle_go_back_tap() {
        let profile: GenericStudent? = GenericStudent(
            id: UUID(),
            name: "name",
            email: "email",
            activeCourses: [],
            completedCourses: []
        )
        let getProfilePublisher = Empty<GenericStudent?, GetStudentProfileError>()
            .eraseToAnyPublisher()
        let updateProfilePublisher = Empty<Void, StudentRepositoryError>()
            .eraseToAnyPublisher()
        let getProfileUseCase = GetStudentProfileUseCaseStub(profile: getProfilePublisher)
        let updateProfileUseCase = UpdateStudentProfileUseCaseStub(result: updateProfilePublisher)
        
        let sut = UpdatePersonalInfoViewModel(
            getUserProfileUseCase: getProfileUseCase,
            updateStudentProfileUseCase: updateProfileUseCase
        )
        
        let expectation = expectation(description: "Back tap should be handled.")
        
        sut.navigateToUserAccount
            .sink(
                receiveValue: {
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.goBackTap.send(())
        
        waitForExpectations(timeout: 0.1)
    }
}
