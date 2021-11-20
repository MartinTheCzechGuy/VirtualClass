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
        container.autoregister(UpdatePersonalInfoView.self, initializer: UpdatePersonalInfoView.init)
        container.autoregister(UserProfileView.self, initializer: UserProfileView.init)
        container.autoregister(UserAccountView.self, initializer: UserAccountView.init)

        container.autoregister(UserProfileViewModel.self, initializer: UserProfileViewModel.init)
            .inObjectScope(.container)
        container.autoregister(UpdatePersonalInfoViewModel.self, initializer: UpdatePersonalInfoViewModel.init)
            .inObjectScope(.container)
        container.autoregister(UserAccountCoordinator.self, initializer: UserAccountCoordinator.init)
            .inObjectScope(.container)
    }
}
