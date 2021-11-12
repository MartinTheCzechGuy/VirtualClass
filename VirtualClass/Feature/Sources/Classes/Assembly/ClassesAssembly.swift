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
//        container.autoregister(ClassDetailView.self, initializer: ClassDetailView.init)
        container.autoregister(ClassListView.self, initializer: ClassListView.init)
        container.autoregister(ClassSearchView.self, initializer: ClassSearchView.init)

        container.register(ClassesCardOverviewViewModel.self) { resolver in
            ClassesCardOverviewViewModel()
        }
        
        container.register(ClassListViewModel.self) { resolver in
            ClassListViewModel()
        }
        
        container.register(ClassSearchViewModel.self) { resolver in
            ClassSearchViewModel()
        }
    }
}
