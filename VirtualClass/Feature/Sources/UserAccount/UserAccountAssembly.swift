//
//  UserAccountAssembly.swift
//  
//
//  Created by Martin on 13.11.2021.
//

import Swinject
import SwinjectAutoregistration

public class UserAccountAssembly: Assembly {

    public init() { }

    public func assemble(container: Container) {
        container.autoregister(PersonalInfoView.self, initializer: PersonalInfoView.init)
        container.autoregister(PersonalInfoView.self, initializer: PersonalInfoView.init)
        
        container.autoregister(UserAccountViewModel.self, initializer: UserAccountViewModel.init)
            .inObjectScope(.container)
        container.autoregister(PersonalInfoViewModel.self, initializer: PersonalInfoViewModel.init)
            .inObjectScope(.container)
        container.autoregister(UserAccountCoordinator.self, initializer: UserAccountCoordinator.init)
            .inObjectScope(.container)
    }
}
