//
//  UpdatePersonalInfoViewModel.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Combine
import CombineExt
import UserSDK
import Foundation

enum UpdatePersonalInfoError: Error {
    case errorLoadingProfile
    case errorUpdatingProfile
}

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
    let reloadDataSubject = PassthroughSubject<Void, Never>()
    
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
        reloadDataSubject
            .flatMap { [weak self] _ -> AnyPublisher<GenericStudent?, Never> in
                guard let self = self else {
                    return Empty().eraseToAnyPublisher()
                }
                
                return self.getUserProfileUseCase.userProfile
                    .replaceError(with: nil)
                    .eraseToAnyPublisher()
            }
            .compactMap { $0 }
            .map { UserPersonalInfo(name: $0.name, email: $0.email) }
            .receive(on: DispatchQueue.main)
            .assign(to: \.userInfo, on: self)
            .store(in: &bag)

        let updateProfileResult = saveChangesTap
            .flatMap { [weak self] _ -> AnyPublisher<GenericStudent?, UpdatePersonalInfoError> in
                guard let self = self else {
                    return Fail(error: UpdatePersonalInfoError.errorLoadingProfile)
                        .eraseToAnyPublisher()
                }
                
                return self.getUserProfileUseCase.userProfile
                    .mapError { _ in UpdatePersonalInfoError.errorLoadingProfile }
                    .eraseToAnyPublisher()
            }
            .flatMap { [weak self] nonUpdatedProfile -> AnyPublisher<Result<Void, UpdatePersonalInfoError>, Never> in
                guard let self = self, let nonUpdatedProfile = nonUpdatedProfile else {
                    return Just(.failure(UpdatePersonalInfoError.errorLoadingProfile))
                        .eraseToAnyPublisher()
                }
                
                let updatedProfile = GenericStudent(
                    id: nonUpdatedProfile.id,
                    name: self.userInfo.name,
                    email: self.userInfo.email,
                    activeCourses: nonUpdatedProfile.activeCourses,
                    completedCourses: nonUpdatedProfile.completedCourses
                )
                
                return self.updateStudentProfileUseCase.update(updatedProfile)
                    .mapError { _ in UpdatePersonalInfoError.errorUpdatingProfile }
                    .mapToResult()
                    .eraseToAnyPublisher()
            }
            .mapToResult()
            .share(replay: 1)

        updateProfileResult
            .compactMap(\.success)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.userProfileUpdatedSubject.send()
            })
            .store(in: &bag)
        
        updateProfileResult
            .compactMap(\.failure)
            .map { _ in "Error updating user profile." }
            .receive(on: DispatchQueue.main)
            .assign(to: \.errorUpdatingProfile, on: self)
            .store(in: &bag)
    }
}
