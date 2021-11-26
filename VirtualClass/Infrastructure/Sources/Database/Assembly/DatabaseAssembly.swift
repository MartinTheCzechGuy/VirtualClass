//
//  DatabaseAssembly.swift
//
//
//  Created by Martin on 17.11.2021.
//

import Swinject
import SwinjectAutoregistration

public class DatabaseAssembly: Assembly {

    public init() { }

    public func assemble(container: Container) {
        container.autoregister(SQLDBManaging.self, initializer: SQLDBManager.init)
        
        container.autoregister(DatabaseInteracting.self, initializer: CourseDBRepository.init)
            
        container.register(TeacherConverter.self) { _ in
            TeacherConverter.live()
        }
        
        container.register(ClassRoomConverter.self) { _ in
            ClassRoomConverter.live()
        }
    }
}
