//
//  AuthAssembly.swift
//  
//
//  Created by Martin on 10.11.2021.
//

import Swinject
import SwinjectAutoregistration
import UserSDK

public class AuthAssembly: Assembly {

    public init() { }

    public func assemble(container: Container) {
        container.autoregister(LoginView.self, initializer: LoginView.init)
        container.autoregister(RegistrationView.self, initializer: RegistrationView.init)
        container.autoregister(WelcomeView.self, initializer: WelcomeView.init)
        
        container.autoregister(WelcomeViewModel.self, initializer: WelcomeViewModel.init)
            .inObjectScope(.container)
        
        container.autoregister(RegistrationViewModel.self, initializer: RegistrationViewModel.init)
            .inObjectScope(.container)
        
        container.autoregister(LoginViewModel.self, initializer: LoginViewModel.init)
            .inObjectScope(.container)
        
        
        container.autoregister(AuthView.self, initializer: AuthView.init)
        container.autoregister(AuthCoordinator.self, initializer: AuthCoordinator.init)
    }
}
