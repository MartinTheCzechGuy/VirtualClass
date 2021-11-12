//
//  DashboardCoordinator.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Calendar
import Combine
import Classes
import UserAccount

public final class DashboardCoordinator: ObservableObject {
    
    @Published var classOverviewViewModel: ClassesCardOverviewViewModel
    @Published var userAccountCoordinator: UserAccountCoordinator
    @Published var calendarViewModel: CalendarViewModel
    
    @Published var classSearchViewModel: ClassSearchViewModel?
    @Published var personalInfoViewModel: PersonalInfoViewModel?
    @Published var classListViewModel: ClassListViewModel?
    
    private var bag = Set<AnyCancellable>()
    
    public init(
        userAccountCoordinator: UserAccountCoordinator,
        classOverviewViewModel: ClassesCardOverviewViewModel,
        calendarViewModel: CalendarViewModel
    ) {
        self.userAccountCoordinator = userAccountCoordinator
        self.classOverviewViewModel = classOverviewViewModel
        self.calendarViewModel = calendarViewModel
        
        setupBindings()
    }
    
    private func setupBindings() {
        userAccountCoordinator.$classSearchViewModel
            .assign(to: \.classSearchViewModel, on: self)
            .store(in: &bag)
        
        userAccountCoordinator.$personalInfoViewModel
            .assign(to: \.personalInfoViewModel, on: self)
            .store(in: &bag)
        
        userAccountCoordinator.$classListViewModel
            .assign(to: \.classListViewModel, on: self)
            .store(in: &bag)
    }
}
