//
//  MainCoordinator.swift
//  
//
//  Created by Martin on 12.11.2021.
//

import Auth
import Combine
import Dashboard
import InstanceProvider
import UserSDK

public final class MainCoordinator: ObservableObject  {
    
    enum ActiveScreen {
        case auth
        case dashboard
    }
    
    // MARK: - Coordinator to Coordinator View
    
    @Published var activeScreen: ActiveScreen
    
    // MARK: Private
    
    @Published private var authCoordinator: AuthCoordinator
    @Published private var dashboardCoordinator: DashboardCoordinator
    
    private var bag = Set<AnyCancellable>()
    
    private let isUserLoggedInUseCase: IsUserLoggedInUseCaseType
    
    init(
        authCoordinator: AuthCoordinator,
        dashboardCoordinator: DashboardCoordinator,
        isUserLoggedInUseCase: IsUserLoggedInUseCaseType
    ) {
        self.authCoordinator = authCoordinator
        self.dashboardCoordinator = dashboardCoordinator
        self.isUserLoggedInUseCase = isUserLoggedInUseCase
        self.activeScreen = isUserLoggedInUseCase.isUserLogged ? .dashboard : .auth
        
        setupBindings()
    }
    
    private func setupBindings() {
        authCoordinator.authSuccessful
            .map { ActiveScreen.dashboard }
            .assign(to: \.activeScreen, on: self)
            .store(in: &bag)
        
        dashboardCoordinator.didLogout
            .map { ActiveScreen.auth }
            .assign(to: \.activeScreen, on: self)
            .store(in: &bag)
    }
}
