//
//  InstanceProvider.swift
//  
//
//  Created by Martin on 10.11.2021.
//

public protocol InstanceProvider {
    func resolve<Instance>(_ type: Instance.Type) -> Instance
}
