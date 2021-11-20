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
        container.autoregister(CourseCardsOverviewView.self, initializer: CourseCardsOverviewView.init)
        container.autoregister(ClassListView.self, initializer: ClassListView.init)
        container.autoregister(ClassSearchView.self, initializer: ClassSearchView.init)
        container.autoregister(HomeView.self, initializer: HomeView.init)
        
        container.autoregister(CourseCardsOverviewViewModel.self, initializer: CourseCardsOverviewViewModel.init)
            .inObjectScope(.container)
        container.autoregister(ClassListViewModel.self, initializer: ClassListViewModel.init)
            .inObjectScope(.container)
        container.autoregister(ClassSearchViewModel.self, initializer: ClassSearchViewModel.init)
            .inObjectScope(.container)
        container.autoregister(HomeCoordinator.self, initializer: HomeCoordinator.init)
            .inObjectScope(.container)
    }
}
