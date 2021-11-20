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
        container.autoregister(CourseSearchView.self, initializer: CourseSearchView.init)
        container.autoregister(HomeView.self, initializer: HomeView.init)
        container.autoregister(CompletedCoursesView.self, initializer: CompletedCoursesView.init)

        container.autoregister(CompletedCoursesViewModel.self, initializer: CompletedCoursesViewModel.init)
            .inObjectScope(.container)
        container.autoregister(CourseCardsOverviewViewModel.self, initializer: CourseCardsOverviewViewModel.init)
            .inObjectScope(.container)
        container.autoregister(CourseSearchViewModel.self, initializer: CourseSearchViewModel.init)
            .inObjectScope(.container)
        container.autoregister(HomeCoordinator.self, initializer: HomeCoordinator.init)
            .inObjectScope(.container)
    }
}
