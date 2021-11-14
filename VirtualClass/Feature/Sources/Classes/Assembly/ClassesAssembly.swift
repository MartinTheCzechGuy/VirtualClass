//
//  ClassesAssembly.swift
//  
//
//  Created by Martin on 12.11.2021.
//

import Swinject
import SwinjectAutoregistration

public class ClassesAssembly: Assembly {

    public init() { }

    public func assemble(container: Container) {
        container.autoregister(ClassesCardOverviewView.self, initializer: ClassesCardOverviewView.init)
        container.autoregister(ClassListView.self, initializer: ClassListView.init)
        container.autoregister(ClassSearchView.self, initializer: ClassSearchView.init)

        container.autoregister(ClassesCardOverviewViewModel.self, initializer: ClassesCardOverviewViewModel.init)
            .inObjectScope(.container)
        container.autoregister(ClassListViewModel.self, initializer: ClassListViewModel.init)
            .inObjectScope(.container)
        container.autoregister(ClassSearchViewModel.self, initializer: ClassSearchViewModel.init)
            .inObjectScope(.container)
    }
}
