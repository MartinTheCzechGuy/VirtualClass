//
//  DatabaseAssembly.swift
//  
//
//  Created by Martin on 12.11.2021.
//

import Swinject
import SwinjectAutoregistration

public class DatabaseAssembly: Assembly {

    public init() { }

    public func assemble(container: Container) {        
        container.autoregister(UserDBRepositoryType.self, initializer: UserDBRepository.init)
//        container.autoregister(ClassDBRepositoryType.self, initializer: ClassDBRepository.init)
    }
}
