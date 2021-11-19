//
//  UserSDKAssembly.swift
//  
//
//  Created by Martin on 12.11.2021.
//

import Swinject
import SwinjectAutoregistration
import Database

public class UserSDKAssembly: Assembly {

    public init() { }

    public func assemble(container: Container) {
    
        // MARK: - User Auth
        
        container.autoregister(UserAuthRepositoryType.self, initializer: UserAuthRepository.init)
            .inObjectScope(.container)
        
        container.autoregister(CheckValidPasswordUseCaseType.self, initializer: CheckValidPasswordUseCase.init)
        container.autoregister(CheckValidEmailUseCaseType.self, initializer: CheckValidEmailUseCase.init)
        container.autoregister(CheckEmailTakenUseCaseType.self, initializer: CheckEmailTakenUseCase.init)
        container.autoregister(HandleUserLoginUseCaseType.self, initializer: HandleUserLoginUseCase.init)
        container.autoregister(HandleUserRegistrationUseCaseType.self, initializer: HandleUserRegistrationUseCase.init)
        container.autoregister(HandleLogOutUseCaseType.self, initializer: HandleLogOutUseCase.init)
        container.autoregister(IsEmailUsedUseCasetype.self, initializer: IsEmailUsedUseCase.init)
        container.autoregister(IsUserLoggedInUseCaseType.self, initializer: IsUserLoggedInUseCase.init)

        // MARK: User Profile
        
        container.autoregister(UserProfileRepositoryType.self, initializer: UserProfileRepository.init)
            .inObjectScope(.container)
        
        container.autoregister(UpdateUserProfileUseCaseType.self, initializer: UpdateUserProfileUseCase.init)
        container.autoregister(CreateStudentProfileUseCaseType.self, initializer: CreateStudentProfileUseCase.init)
        container.autoregister(GetUserProfileUseCaseType.self, initializer: GetUserProfileUseCase.init)
        container.autoregister(GetLoggedInUserUseCaseType.self, initializer: GetLoggedInUserUseCase.init)
    }
}
