//
//  UserSDKAssembly.swift
//  
//
//  Created by Martin on 12.11.2021.
//

import Swinject
import SwinjectAutoregistration
import Database

public class UserSDKAssembly: Assembly {

    public init() { }

    public func assemble(container: Container) {
        container.register(UserProfileRepositoryType.self) { resolver in
            let database = resolver.resolve(DatabaseInteracting.self, name: "UserEntityDBInteracting")!
            
            return UserProfileRepository(database: database)
        }
    }
}
