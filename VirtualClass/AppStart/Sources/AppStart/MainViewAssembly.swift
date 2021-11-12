//
//  MainViewAssembly.swift
//  
//
//  Created by Martin on 12.11.2021.
//

import Swinject
import SwinjectAutoregistration
import Auth

public class MainViewAssembly: Assembly {

    public init() { }

    public func assemble(container: Container) {
        container.autoregister(MainView.self, initializer: MainView.init)
        
        container.register(MainCoordinator.self) { resolver in
            MainCoordinator(welcomeViewModel: resolver.resolve(WelcomeViewModel.self)!)
        }
    }
}
