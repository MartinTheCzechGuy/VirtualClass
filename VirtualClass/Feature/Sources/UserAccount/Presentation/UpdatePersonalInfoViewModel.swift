//
//  UpdatePersonalInfoViewModel.swift
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

public final class UpdatePersonalInfoViewModel: ObservableObject {
    
    // MARK: - Inputs
    @Published var userInfo: UserPersonalInfo = UserPersonalInfo(name: "", email: "")
    @Published var errorUpdatingProfile: String? = nil
    
    // MARK: - Outputs
    let saveChangesTap = PassthroughSubject<Void, Never>()
    let goBackTap = PassthroughSubject<Void, Never>()
    
    // MARK: - Actions
    let navigateToUserAccount: AnyPublisher<Void, Never>
    
    // MARK: - Private
    private let getUserProfileUseCase: GetStudentProfileUseCaseType
    private let updateStudentProfileUseCase: UpdateStudentProfileUseCaseType
    
    private let userProfileUpdatedSubject = PassthroughSubject<Void, Never>()
    private var bag: Set<AnyCancellable> = []
    
    init(
        getUserProfileUseCase: GetStudentProfileUseCaseType,
        updateStudentProfileUseCase: UpdateStudentProfileUseCaseType
    ) {
        self.getUserProfileUseCase = getUserProfileUseCase
        self.updateStudentProfileUseCase = updateStudentProfileUseCase
        self.navigateToUserAccount = goBackTap
            .merge(with: userProfileUpdatedSubject)
            .eraseToAnyPublisher()
        
        setupBindings()
    }
    
    private func setupBindings() {
        let updateProfileResult = saveChangesTap
            .compactMap { [weak self] _ -> GenericStudent? in
                guard let self = self else { return nil }
                
                return self.getUserProfileUseCase.userProfile
            }
            .compactMap { [weak self] nonUpdatedProfile -> Result<Void, UserRepositoryError>? in
                guard let self = self else { return nil }
                
                let updatedProfile = GenericStudent(
                    id: nonUpdatedProfile.id,
                    name: self.userInfo.name,
                    email: self.userInfo.email,
                    activeCourses: nonUpdatedProfile.activeCourses,
                    completedCourses: nonUpdatedProfile.completedCourses
                )
                
                return self.updateStudentProfileUseCase.update(updatedProfile)
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
        guard let profile = getUserProfileUseCase.userProfile else {
            return
        }
        
        userInfo = UserPersonalInfo(name: profile.name, email: profile.email)
    }
}
