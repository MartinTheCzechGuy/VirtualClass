//
//  SwinjectInstanceProvider.swift
//  
//
//  Created by Martin on 10.11.2021.
//

import Swinject

class SwinjectInstanceProvider: InstanceProvider {

    let resolver: Resolver

    init(resolver: Resolver) {
        self.resolver = resolver
    }

    func resolve<Instance>(_ type: Instance.Type) -> Instance {
        guard let instance = resolver.resolve(type) else {
            fatalError("Could not resolve an instance of \(type) -> check if you registered it correctly.")
        }
        
        return instance
    }
}
