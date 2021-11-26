//
//  UserProfileViewModel.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Common
import Combine
import UserSDK
import SwiftUI

public final class UserProfileViewModel: ObservableObject {
    
    // Inputs
    @Published var userProfile: GenericStudent?
    
    // Outputs
    let personalInfoTap = PassthroughSubject<Void, Never>()
    let addNewClassTap = PassthroughSubject<Void, Never>()
    let logoutTap = PassthroughSubject<Void, Never>()
    let showCompletedCoursesTap = PassthroughSubject<Void, Never>()
    let reloadProfileSubject = PassthroughSubject<Void, Never>()
    
    // View Model to Coordinator
    let navigateToCompletedCourses: AnyPublisher<Void, Never>
    let navigateToClassSearch: AnyPublisher<Void, Never>
    let navigateToPersonalInfo: AnyPublisher<GenericStudent, Never>
    let didLogout: AnyPublisher<Void, Never>
    
    // Private
    private let getUserProfileUseCase: GetStudentProfileUseCaseType
    private let handleLogOutUseCase: HandleLogOutUseCaseType
    
    private let navigateToPersonalInfoSubject = PassthroughSubject<GenericStudent, Never>()
    private let didLogoutSubject = PassthroughSubject<Void, Never>()
    private var bag = Set<AnyCancellable>()
    
    public init(getUserProfileUseCase: GetStudentProfileUseCaseType, handleLogOutUseCase: HandleLogOutUseCaseType) {
        self.getUserProfileUseCase = getUserProfileUseCase
        self.handleLogOutUseCase = handleLogOutUseCase
        self.navigateToClassSearch = addNewClassTap.eraseToAnyPublisher()
        self.navigateToPersonalInfo = navigateToPersonalInfoSubject.eraseToAnyPublisher()
        self.didLogout = didLogoutSubject.eraseToAnyPublisher()
        self.navigateToCompletedCourses = showCompletedCoursesTap.eraseToAnyPublisher()
        
        reloadProfileSubject
            .flatMap { [weak self] _ -> AnyPublisher<GenericStudent?, Never> in
                guard let self = self else {
                    return Empty<GenericStudent?, Never>().eraseToAnyPublisher()
                }
                
                return self.getUserProfileUseCase.userProfile
                    .replaceError(with: nil)
                    .eraseToAnyPublisher()
            }
            .assign(to: \.userProfile, on: self)
            .store(in: &bag)
        
        personalInfoTap
            .compactMap { [weak self] _ in self?.userProfile }
            .sink(receiveValue: { [weak self] userProfile in
                self?.navigateToPersonalInfoSubject.send(userProfile)
            })
            .store(in: &bag)
        
        logoutTap
            .compactMap { [weak self] _ in
                self?.handleLogOutUseCase.logout()
            }
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                
                self.didLogoutSubject.send(())
            })
            .store(in: &bag)
    }
}
