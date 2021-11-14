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
    @Published var logoutUnsuccessful = false
    @Published var userProfile: UserProfile?
    
    // Outputs
    let personalInfoTap = PassthroughSubject<Void, Never>()
    let currentlyStudiedClassesTap = PassthroughSubject<Void, Never>()
    let addNewClassTap = PassthroughSubject<Void, Never>()
    let logoutTap = PassthroughSubject<Void, Never>()
    
    // Actions
    let navigateToClassSearch: AnyPublisher<Void, Never>
    let navigateToPersonalInfo: AnyPublisher<UserProfile, Never>
    let navigateToClassList: AnyPublisher<Void, Never>
    public let didLogout: AnyPublisher<Void, Never>
    
    // Private
    private let getUserProfileUseCase: GetUserProfileUseCaseType
    private let handleLogOutUseCase: HandleLogOutUseCaseType
    
    private let navigateToPersonalInfoSubject = PassthroughSubject<UserProfile, Never>()
    private let didLogoutSubject = PassthroughSubject<Void, Never>()
    private var bag = Set<AnyCancellable>()
    
    public init(getUserProfileUseCase: GetUserProfileUseCaseType, handleLogOutUseCase: HandleLogOutUseCaseType) {
        self.getUserProfileUseCase = getUserProfileUseCase
        self.handleLogOutUseCase = handleLogOutUseCase
        self.navigateToClassSearch = addNewClassTap.eraseToAnyPublisher()
        self.navigateToClassList = currentlyStudiedClassesTap.eraseToAnyPublisher()
        self.navigateToPersonalInfo = navigateToPersonalInfoSubject.eraseToAnyPublisher()
        self.didLogout = didLogoutSubject.eraseToAnyPublisher()
        
        
        self.userProfile = getUserProfileUseCase.userProfile
        
        personalInfoTap
            .compactMap { [weak self] _ in self?.userProfile }
            .sink(receiveValue: { [weak self] userProfile in
                self?.navigateToPersonalInfoSubject.send(userProfile)
            })
            .store(in: &bag)
        
        let logoutResult = logoutTap
            .compactMap { [weak self] _ -> Result<Void, UserAuthRepositoryError>? in
                self?.handleLogOutUseCase.logout()
            }
            .share()
        
        logoutResult
            .compactMap { result -> Bool? in
                guard result.failure != nil else {
                    return nil
                }
                
                return true
            }
            .assign(to: \.logoutUnsuccessful, on: self)
            .store(in: &bag)
        
        logoutResult
            .compactMap(\.success)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                
                self.didLogoutSubject.send(())
            })
            .store(in: &bag)
    }
    
    func reloadProfile() {
        self.userProfile = getUserProfileUseCase.userProfile
    }
}
