//
//  AuthAssembly.swift
//  
//
//  Created by Martin on 10.11.2021.
//

import Swinject
import SwinjectAutoregistration

public class AuthAssembly: Assembly {

    public init() { }

    public func assemble(container: Container) {
        container.autoregister(LoginView.self, initializer: LoginView.init)
        container.autoregister(RegistrationView.self, initializer: RegistrationView.init)
        container.autoregister(WelcomeView.self, initializer: WelcomeView.init)
        
        container.register(WelcomeViewModel.self) { resolver in
            WelcomeViewModel()
        }
        
        container.register(RegistrationViewModel.self) { resolver in
            RegistrationViewModel()
        }
        
        container.register(LoginViewModel.self) { resolver in
            LoginViewModel()
        }
    }
}
