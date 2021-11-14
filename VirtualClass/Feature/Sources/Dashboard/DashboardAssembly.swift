//
//  DashboardAssembly.swift
//  
//
//  Created by Martin on 13.11.2021.
//

import Swinject
import SwinjectAutoregistration

public class DashboardAssembly: Assembly {

    public init() { }

    public func assemble(container: Container) {
        container.autoregister(DashboardView.self, initializer: DashboardView.init)
        
        container.autoregister(DashboardCoordinator.self, initializer: DashboardCoordinator.init)
            .inObjectScope(.container)
    }
}
