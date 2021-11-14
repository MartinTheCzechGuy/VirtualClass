//
//  UserAccountAssembly.swift
//  
//
//  Created by Martin on 13.11.2021.
//

import Swinject
import SwinjectAutoregistration
import UserSDK

public class UserAccountAssembly: Assembly {

    public init() { }

    public func assemble(container: Container) {
        container.autoregister(PersonalInfoView.self, initializer: PersonalInfoView.init)
        container.autoregister(UserProfileView.self, initializer: UserProfileView.init)
        container.autoregister(UserAccountView.self, initializer: UserAccountView.init)

        container.autoregister(UserProfileViewModel.self, initializer: UserProfileViewModel.init)
            .inObjectScope(.container)
        container.autoregister(PersonalInfoViewModel.self, initializer: PersonalInfoViewModel.init)
            .inObjectScope(.container)
        container.autoregister(UserAccountCoordinator.self, initializer: UserAccountCoordinator.init)
            .inObjectScope(.container)
    }
}
