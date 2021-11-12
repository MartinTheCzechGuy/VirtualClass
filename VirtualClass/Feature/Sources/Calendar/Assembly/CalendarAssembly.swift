//
//  CalendarAssembly.swift
//  
//
//  Created by Martin on 12.11.2021.
//

import Swinject
import SwinjectAutoregistration

public class CalendarAssembly: Assembly {

    public init() { }

    public func assemble(container: Container) {
        container.autoregister(CalendarView.self, initializer: CalendarView.init)
                
        container.register(CalendarViewModel.self) { resolver in
            CalendarViewModel()
        }
    }
}
