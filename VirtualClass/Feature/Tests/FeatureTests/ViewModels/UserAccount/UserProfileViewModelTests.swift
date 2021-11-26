//
//  UserProfileViewModelTests.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import Foundation
import UserSDK
import XCTest
@testable import UserAccount

final class UserProfileViewModelTests: XCTestCase {
    
    private var bag = Set<AnyCancellable>()
    
    override func tearDown() {
        bag.removeAll()
        
        super.tearDown()
    }
    
    func test_reload_profile_data_success() {
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
        let getProfileUseCase = GetStudentProfileUseCaseStub(profile: getProfilePublisher)
        let handleLogoutUseCase = HandleLogOutUseCaseStub()
        
        let sut = UserProfileViewModel(getUserProfileUseCase: getProfileUseCase, handleLogOutUseCase: handleLogoutUseCase)
        
        let expectation = expectation(description: "Profile should be reloaded.")
        
        sut.$userProfile
            .dropFirst()
            .sink(
                receiveValue: { result in
                    XCTAssertEqual(result?.id, profile?.id)
                    XCTAssertFalse(handleLogoutUseCase.haveBeenCalled)
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.reloadProfileSubject.send(())
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_reload_profile_data_failure() {
        let getProfilePublisher = Fail<GenericStudent?, GetStudentProfileError>(error: .init(cause: .emailNotFound))
            .eraseToAnyPublisher()
        let getProfileUseCase = GetStudentProfileUseCaseStub(profile: getProfilePublisher)
        let handleLogoutUseCase = HandleLogOutUseCaseStub()
        
        let sut = UserProfileViewModel(getUserProfileUseCase: getProfileUseCase, handleLogOutUseCase: handleLogoutUseCase)
        
        let expectation = expectation(description: "Error reloading profile should be suppressed")
        
        sut.$userProfile
            .dropFirst()
            .sink(
                receiveValue: { result in
                    XCTAssertEqual(result?.id, nil)
                    XCTAssertFalse(handleLogoutUseCase.haveBeenCalled)
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.reloadProfileSubject.send(())
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_logout_handled() {
        let getProfilePublisher = Empty<GenericStudent?, GetStudentProfileError>()
            .eraseToAnyPublisher()
        let getProfileUseCase = GetStudentProfileUseCaseStub(profile: getProfilePublisher)
        let handleLogoutUseCase = HandleLogOutUseCaseStub()
        
        let sut = UserProfileViewModel(getUserProfileUseCase: getProfileUseCase, handleLogOutUseCase: handleLogoutUseCase)
        
        let expectation = expectation(description: "Logout tap should be handled")
        
        sut.didLogout
            .sink(
                receiveValue: {
                    XCTAssertTrue(handleLogoutUseCase.haveBeenCalled)
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.logoutTap.send(())
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_personal_info_tap_not_propagated_without_profile() {
        let getProfilePublisher = Empty<GenericStudent?, GetStudentProfileError>()
            .eraseToAnyPublisher()
        let getProfileUseCase = GetStudentProfileUseCaseStub(profile: getProfilePublisher)
        let handleLogoutUseCase = HandleLogOutUseCaseStub()
        
        let sut = UserProfileViewModel(getUserProfileUseCase: getProfileUseCase, handleLogOutUseCase: handleLogoutUseCase)
        
        let expectation = expectation(description: "Personal info tap should not be propagated without user profile fetched.")
        expectation.isInverted = true
        
        sut.navigateToPersonalInfo
            .sink(
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.personalInfoTap.send(())
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_personal_info_tap_propagated() {
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
        let getProfileUseCase = GetStudentProfileUseCaseStub(profile: getProfilePublisher)
        let handleLogoutUseCase = HandleLogOutUseCaseStub()
        
        let sut = UserProfileViewModel(getUserProfileUseCase: getProfileUseCase, handleLogOutUseCase: handleLogoutUseCase)
        
        let expectation = expectation(description: "Personal info tap should be propagated with user profile fetched.")
        
        sut.navigateToPersonalInfo
            .sink(
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.reloadProfileSubject.send(())
        sut.personalInfoTap.send(())
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_completed_courses_tap_handled() {
        let getProfilePublisher = Empty<GenericStudent?, GetStudentProfileError>()
            .eraseToAnyPublisher()
        let getProfileUseCase = GetStudentProfileUseCaseStub(profile: getProfilePublisher)
        let handleLogoutUseCase = HandleLogOutUseCaseStub()
        
        let sut = UserProfileViewModel(getUserProfileUseCase: getProfileUseCase, handleLogOutUseCase: handleLogoutUseCase)
        
        let expectation = expectation(description: "Completed courses tap should be propagated.")
        
        sut.navigateToCompletedCourses
            .sink(
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.showCompletedCoursesTap.send(())
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_course_search_tap_handled() {
        let getProfilePublisher = Empty<GenericStudent?, GetStudentProfileError>()
            .eraseToAnyPublisher()
        let getProfileUseCase = GetStudentProfileUseCaseStub(profile: getProfilePublisher)
        let handleLogoutUseCase = HandleLogOutUseCaseStub()
        
        let sut = UserProfileViewModel(getUserProfileUseCase: getProfileUseCase, handleLogOutUseCase: handleLogoutUseCase)
        
        let expectation = expectation(description: "Completed courses tap should be propagated.")
        
        sut.navigateToClassSearch
            .sink(
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        sut.addNewClassTap.send(())
        
        waitForExpectations(timeout: 0.1)
    }
}
