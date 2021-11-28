//
//  AuthCoordinator.swift
//  
//
//  Created by Martin on 14.11.2021.
//

import Combine
import InstanceProvider

public final class AuthCoordinator: ObservableObject {
    
    enum ActiveScreen: Identifiable {
        //    case welcome
        case login
        case registration
        
        var id: Self {
            self
        }
    }
    
    // MARK: - Coordinator to Coordinator View
    
    @Published var activeScreen: ActiveScreen? = nil
    
    // MARK: - Coordinator to Root Coordinator
    
    public let authSuccessful: AnyPublisher<Void, Never>
    
    // MARK: - Private
    
    @Published private var welcomeViewModel: WelcomeViewModel
    @Published private var loginViewModel: LoginViewModel?
    @Published private var registrationViewModel: RegistrationViewModel?
    
    private let navigateToDashboardSubject = PassthroughSubject<Void, Never>()
    
    private let instanceProvider: InstanceProvider
    
    private var bag = Set<AnyCancellable>()
    private var loginBag = Set<AnyCancellable>()
    private var registrationBag = Set<AnyCancellable>()
    
    init(instanceProvider: InstanceProvider, welcomeViewModel: WelcomeViewModel) {
        self.instanceProvider = instanceProvider
        self.welcomeViewModel = welcomeViewModel
        self.authSuccessful = navigateToDashboardSubject.eraseToAnyPublisher()
        
        setupBindings()
    }
    
    private func setupBindings() {
        welcomeViewModel.actions.loginTap
            .sink(
                receiveValue: { [weak self] viewModel in
                    guard let self = self else { return }
                    
                    self.activeScreen = .login
                    self.loginViewModel = self.instanceProvider.resolve(LoginViewModel.self)
                }
            )
            .store(in: &bag)
        
        welcomeViewModel.actions.registrationTap
            .sink(
                receiveValue: { [weak self] viewModel in
                    guard let self = self else { return }
                    
                    self.activeScreen = .registration
                    self.registrationViewModel = self.instanceProvider.resolve(RegistrationViewModel.self)
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
                            
                            self.activeScreen = nil
                            self.loginViewModel = nil
                        })
                        .store(in: &self.loginBag)
                    
                    viewModel?.navigateToDashboard
                        .sink(receiveValue: { [weak self] _ in
                            guard let self = self else { return }
                            
                            self.loginViewModel = nil
                            self.navigateToDashboardSubject.send(())
                        })
                        .store(in: &self.loginBag)
                    
                    viewModel?.navigateToRegistration
                        .sink(receiveValue: { [weak self] _ in
                            guard let self = self else { return }
                            
                            self.loginViewModel = nil
                            self.activeScreen = .registration
                            self.registrationViewModel = self.instanceProvider.resolve(RegistrationViewModel.self)
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
                        self.navigateToDashboardSubject.send(())
                    })
                    .store(in: &self.registrationBag)
                
                viewModel?.navigateToWelcomeScreen
                    .sink(receiveValue: { [weak self] _ in
                        guard let self = self else { return }
                        
                        self.activeScreen = nil
                        self.registrationViewModel = nil
                    })
                    .store(in: &self.registrationBag)
                
                viewModel?.navigateToSignIn
                    .sink(receiveValue: { [weak self] _ in
                        guard let self = self else { return }
                        
                        self.registrationViewModel = nil
                        self.loginViewModel = self.instanceProvider.resolve(LoginViewModel.self)
                        self.activeScreen = .login
                    })
                    .store(in: &self.registrationBag)
            })
            .store(in: &bag)
    }
}
