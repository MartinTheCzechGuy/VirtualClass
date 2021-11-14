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

public final class MainCoordinator: ObservableObject  {
    
    enum ActiveScreen {
        case auth
        case dashboard
    }
    
    @Published var activeScreen: ActiveScreen = .auth
    
    #warning("TODO - vytvořit vlastní wrapper, který bude dělat to samé (poskytovat publisher for free), ale nebude ho myšlený na vystavování ven")
    @Published var authCoordinator: AuthCoordinator
    @Published var dashboardCoordinator: DashboardCoordinator?
    
    private var bag = Set<AnyCancellable>()
    private var dashboardBag = Set<AnyCancellable>()
    
    init(authCoordinator: AuthCoordinator) {
        self.authCoordinator = authCoordinator
        
        setupBindings()
    }
    
    private func setupBindings() {
        authCoordinator.authSuccessful
            .sink(
                receiveValue: { [weak self] viewModel in
                    guard let self = self else { return }
                    
                    self.dashboardCoordinator = instanceProvider.resolve(DashboardCoordinator.self)
                    self.activeScreen = .dashboard
                }
            )
            .store(in: &bag)
        
        $dashboardCoordinator
            .compactMap { $0 }
            .sink(
                receiveValue: { [weak self] dashboardCoordinator in
                    guard let self = self else { return }
                    
                    self.dashboardBag.removeAll()
                    
                    dashboardCoordinator.didLogout
                        .sink(receiveValue: { [weak self] _ in
                            guard let self = self else { return }
                            
                            self.dashboardCoordinator = nil
                            self.activeScreen = .auth
                        })
                        .store(in: &self.dashboardBag)
                }
            )
            .store(in: &bag)
    }
}
