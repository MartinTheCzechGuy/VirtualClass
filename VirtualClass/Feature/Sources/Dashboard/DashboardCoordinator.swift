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
        
    // Actions
    public let didLogout: AnyPublisher<Void, Never>
    
    // Private
    
    @Published var classOverviewViewModel: ClassesCardOverviewViewModel
    @Published var userAccountCoordinator: UserAccountCoordinator
    @Published var calendarViewModel: CalendarViewModel
    
    private let didLogoutSubject = PassthroughSubject<Void, Never>()
    private var bag = Set<AnyCancellable>()
    
    public init(
        userAccountCoordinator: UserAccountCoordinator,
        classOverviewViewModel: ClassesCardOverviewViewModel,
        calendarViewModel: CalendarViewModel
    ) {
        self.userAccountCoordinator = userAccountCoordinator
        self.classOverviewViewModel = classOverviewViewModel
        self.calendarViewModel = calendarViewModel
        self.didLogout = didLogoutSubject.eraseToAnyPublisher()
        
        setupBindings()
    }
    
    private func setupBindings() {
        userAccountCoordinator.didLogout
            .sink(receiveValue: { [weak self] in
                self?.didLogoutSubject.send()
            })
            .store(in: &bag)
    }
}
