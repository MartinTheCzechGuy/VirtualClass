//
//  PersonalInfoViewModel.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Combine
import UserSDK
import Foundation

struct UserPersonalInfo {
    var name: String
    var email: String
}

public final class PersonalInfoViewModel: ObservableObject {
    
    // MARK: - Inputs
    @Published var userInfo: UserPersonalInfo?
    @Published var errorUpdatingProfile: String? = nil
    
    // MARK: - Outputs
    let saveChangesTap = PassthroughSubject<Void, Never>()
    let goBackTap = PassthroughSubject<Void, Never>()
    
    // MARK: - Actions
    let navigateToUserAccount: AnyPublisher<Void, Never>
    
    // MARK: - Private
    private let getUserProfileUseCase: GetUserProfileUseCaseType
    private let updateUserProfileUseCase: UpdateUserProfileUseCaseType
    
    private let userProfileUpdatedSubject = PassthroughSubject<Void, Never>()
    private var bag: Set<AnyCancellable> = []
    
    init(
        getUserProfileUseCase: GetUserProfileUseCaseType,
        updateUserProfileUseCase: UpdateUserProfileUseCaseType
    ) {
        self.getUserProfileUseCase = getUserProfileUseCase
        self.updateUserProfileUseCase = updateUserProfileUseCase
        self.navigateToUserAccount = goBackTap
            .merge(with: userProfileUpdatedSubject)
            .eraseToAnyPublisher()
        
        setupBindings()
    }
    
    private func setupBindings() {
        let updateProfileResult = saveChangesTap
            .compactMap { [weak self] _ -> UserProfile? in
                guard let self = self else { return nil }
                
                return self.getUserProfileUseCase.userProfile
            }
            .compactMap { [weak self] nonUpdatedProfile -> Result<Void, UserRepositoryError>? in
                guard let self = self else { return nil }
                
                let updatedProfile = UserProfile(
                    id: nonUpdatedProfile.id,
                    name: self.userInfo!.name,
                    email: self.userInfo!.email,
                    classes: nonUpdatedProfile.classes
                )
                
                return self.updateUserProfileUseCase.update(userProfile: updatedProfile)
            }
            .share()
        
        updateProfileResult
            .compactMap(\.success)
            .sink(receiveValue: { [weak self] _ in
                self?.userProfileUpdatedSubject.send()
            })
            .store(in: &bag)
        
        updateProfileResult
            .compactMap(\.failure)
            .map { _ in "baaaac" }
            .assign(to: \.errorUpdatingProfile, on: self)
            .store(in: &bag)
    }
    
    func reloadUserData() {
        self.userInfo = getUserProfileUseCase.userProfile.map { UserPersonalInfo(name: $0.name, email: $0.email) }
    }
}
