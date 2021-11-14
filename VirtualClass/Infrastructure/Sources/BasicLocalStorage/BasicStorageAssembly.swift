//
//  BasicStorageAssembly.swift
//  
//
//  Created by Martin on 13.11.2021.
//

import Swinject
import SwinjectAutoregistration

public class BasicStorageAssembly: Assembly {

    public init() { }

    public func assemble(container: Container) {
        container.register(LocalKeyValueStorage.self) { _ in
            UserDefaultsStorage(defaults: .standard)
        }
    }
}
