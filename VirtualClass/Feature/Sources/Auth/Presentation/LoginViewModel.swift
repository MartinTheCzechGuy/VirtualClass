//
//  LoginViewModel.swift
//  
//
//  Created by Martin on 10.11.2021.
//

import Combine
import Foundation

public final class LoginViewModel: ObservableObject {
    
    @Published var invalidCredentials = false
    
    let registerNewAccountTap = PassthroughSubject<Void, Never>()
    let loginTap = PassthroughSubject<(email: String, password: String), Never>()
    let goBackTap = PassthroughSubject<Void, Never>()
    
    private var bag = Set<AnyCancellable>()
    
    public let navigateToWelcomeScreen: AnyPublisher<Void, Never>
    public let navigateToDashboard: AnyPublisher<Void, Never>
    public let navigateToRegistration: AnyPublisher<Void, Never>
    
    public init() {
        self.navigateToWelcomeScreen = goBackTap.eraseToAnyPublisher()
        self.navigateToRegistration = registerNewAccountTap.eraseToAnyPublisher()

        let passwordEvaluation = loginTap
            .compactMap { email, password -> Bool? in
                return email.isEmpty && password.isEmpty
            }
            .share()
        
        self.navigateToDashboard =  passwordEvaluation
            .filter { areCredentialsOk in
                areCredentialsOk
            }
            .map { _ in return }
            .eraseToAnyPublisher()
            
        
        passwordEvaluation
            .filter { areCredentialsOk in
                !areCredentialsOk
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.invalidCredentials, on: self)
            .store(in: &bag)
    }
}

extension LoginViewModel: Identifiable {}
