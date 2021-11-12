//
//  RootCoordinator.swift
//  
//
//  Created by Martin on 12.11.2021.
//

import Auth
import Combine
import Dashboard

public final class MainCoordinator: ObservableObject  {
        
    @Published var welcomeViewModel: WelcomeViewModel
    @Published var loginViewModel: LoginViewModel?
    @Published var registrationViewModel: RegistrationViewModel?
    @Published var dashboardCoordinator: DashboardCoordinator?
        
    private var bag = Set<AnyCancellable>()
    private var loginBag = Set<AnyCancellable>()
    private var registrationBag = Set<AnyCancellable>()
    
    init(welcomeViewModel: WelcomeViewModel) {
        self.welcomeViewModel = welcomeViewModel
        
        setupBindings()
    }
    
    private func setupBindings() {
        welcomeViewModel.navigateToLogin
            .sink(
                receiveValue: { [weak self] viewModel in
                    guard let self = self else { return }
                    
                    self.loginViewModel = LoginViewModel()
                }
            )
            .store(in: &bag)
        
        welcomeViewModel.navigateToRegistration
            .sink(
                receiveValue: { [weak self] viewModel in
                    guard let self = self else { return }
                    
                    self.registrationViewModel = RegistrationViewModel()
                }
            )
            .store(in: &bag)
        
        $loginViewModel
            .sink(
                receiveValue: { [weak self] viewModel in
                    guard let self = self else { return }
                    
                    self.loginBag.removeAll()
                    
                    viewModel?.navigateToWelcomeScreen
                        .sink(receiveValue: { [weak self] _ in
                            guard let self = self else { return }
                            
                            self.loginViewModel = nil
                        })
                        .store(in: &self.loginBag)
                    
                    viewModel?.navigateToDashboard
                        .sink(receiveValue: { [weak self] _ in
                            guard let self = self else { return }
                            
                            self.loginViewModel = nil
                            self.dashboardCoordinator = DashboardCoordinator(
                                userAccountCoordinator: .init(userAccountViewModel: .init()),
                                classOverviewViewModel: .init(),
                                calendarViewModel: .init()
                            )
                        })
                        .store(in: &self.loginBag)
                    
                    viewModel?.navigateToRegistration
                        .sink(receiveValue: { [weak self] _ in
                            guard let self = self else { return }
                            
                            self.loginViewModel = nil
                            self.registrationViewModel = RegistrationViewModel()
                        })
                        .store(in: &self.loginBag)
                }
            )
            .store(in: &bag)
        
            $registrationViewModel
                .sink(receiveValue: { [weak self] viewModel in
                    guard let self = self else { return }
                    
                    self.registrationBag.removeAll()
                    
                    viewModel?.navigateToDashboard
                        .sink(receiveValue: { [weak self] _ in
                            guard let self = self else { return }
                            
                            self.registrationViewModel = nil
                            self.dashboardCoordinator = DashboardCoordinator(
                                userAccountCoordinator: .init(userAccountViewModel: .init()),
                                classOverviewViewModel: .init(),
                                calendarViewModel: .init()
                            )
                        })
                        .store(in: &self.registrationBag)
                    
                    viewModel?.navigateToWelcomeScreen
                        .sink(receiveValue: { [weak self] _ in
                            guard let self = self else { return }
                            
                            self.registrationViewModel = nil
                        })
                        .store(in: &self.registrationBag)
                    
                    viewModel?.navigateToSignIn
                        .sink(receiveValue: { [weak self] _ in
                            guard let self = self else { return }
                            
                            self.registrationViewModel = nil
                            self.loginViewModel = LoginViewModel()
                        })
                        .store(in: &self.registrationBag)
                    
                })
                .store(in: &bag)
    }
}
