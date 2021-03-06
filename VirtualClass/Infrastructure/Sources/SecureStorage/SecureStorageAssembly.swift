//
//  SecureStorageAssembly.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Swinject
import SwinjectAutoregistration

public class SecureStorageAssembly: Assembly {

    public init() { }

    public func assemble(container: Container) {
        container.autoregister(SecureStorage.self) {
            KeychainStorage(secureStoreQueryable: UserPassword(service: "VirtualClass", accessGroup: nil))
        }
    }
}
