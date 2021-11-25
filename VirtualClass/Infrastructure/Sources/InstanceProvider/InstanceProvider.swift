//
//  InstanceProvider.swift
//  
//
//  Created by Martin on 10.11.2021.
//

public protocol InstanceProvider {
    func resolve<Instance>(_ type: Instance.Type) -> Instance
    func resolve<Instance, Arg>(_ type: Instance.Type, argument: Arg) -> Instance
    func resolve<Instance, Arg, Arg1, Arg2>(
        _ type: Instance.Type,
        argument: Arg,
        argument1: Arg1,
        argument2: Arg2
    ) -> Instance

}
