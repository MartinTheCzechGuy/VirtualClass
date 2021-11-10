//
//  LoginAssembly.swift
//  
//
//  Created by Martin on 10.11.2021.
//

import Swinject
import SwinjectAutoregistration

public class LoginAssembly: Assembly {

    public init() { }

    public func assemble(container: Container) {        
        container.autoregister(LoginView.self, initializer: LoginView.init)
        container.autoregister(LoginViewModel.self, initializer: LoginViewModel.init)
    }
}
